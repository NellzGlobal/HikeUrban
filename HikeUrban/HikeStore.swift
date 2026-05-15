import Foundation
import Combine
import SwiftUI
import MapKit
import UIKit

// MARK: - Completed Hike (persisted record)

struct CompletedHike: Identifiable, Codable {
    let id: UUID
    var name: String
    var date: Date
    var distanceMiles: Double
    var elevationGainFt: Double
    var durationSeconds: Int
    var floorsAscended: Int
    var steps: Int
    var mode: RouteMode
    var routeCoordinates: [RouteCoordinate]
    var mapSnapshotData: Data?
    var notes: String

    init(id: UUID, name: String, date: Date, distanceMiles: Double, elevationGainFt: Double,
         durationSeconds: Int, floorsAscended: Int, steps: Int, mode: RouteMode,
         routeCoordinates: [RouteCoordinate], mapSnapshotData: Data? = nil, notes: String = "") {
        self.id = id; self.name = name; self.date = date
        self.distanceMiles = distanceMiles; self.elevationGainFt = elevationGainFt
        self.durationSeconds = durationSeconds; self.floorsAscended = floorsAscended
        self.steps = steps; self.mode = mode
        self.routeCoordinates = routeCoordinates; self.mapSnapshotData = mapSnapshotData
        self.notes = notes
    }

    // Forward-compatible decoder: new fields fall back to defaults so old saved
    // hikes (missing these keys) still load instead of silently wiping the list.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id              = try c.decode(UUID.self,   forKey: .id)
        name            = try c.decode(String.self, forKey: .name)
        date            = try c.decode(Date.self,   forKey: .date)
        distanceMiles   = try c.decode(Double.self, forKey: .distanceMiles)
        elevationGainFt = try c.decode(Double.self, forKey: .elevationGainFt)
        durationSeconds = try c.decode(Int.self,    forKey: .durationSeconds)
        floorsAscended  = try c.decodeIfPresent(Int.self,              forKey: .floorsAscended)  ?? 0
        steps           = try c.decodeIfPresent(Int.self,              forKey: .steps)           ?? 0
        mode            = try c.decodeIfPresent(RouteMode.self,        forKey: .mode)            ?? .walk
        routeCoordinates = try c.decodeIfPresent([RouteCoordinate].self, forKey: .routeCoordinates) ?? []
        mapSnapshotData = try c.decodeIfPresent(Data.self,             forKey: .mapSnapshotData)
        notes           = try c.decodeIfPresent(String.self,           forKey: .notes)           ?? ""
    }

    var durationFormatted: String {
        let h = durationSeconds / 3600
        let m = (durationSeconds % 3600) / 60
        return h > 0 ? "\(h)h \(m)m" : "\(m) min"
    }

    var dateFormatted: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }

    var mapImage: UIImage? {
        guard let data = mapSnapshotData else { return nil }
        return UIImage(data: data)
    }

    func gpxFileURL() -> URL? {
        var lines = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<gpx version=\"1.1\" creator=\"HikeUrban\" xmlns=\"http://www.topografix.com/GPX/1/1\">",
            "  <trk>",
            "    <name>\(name.xmlEscaped)</name>"
        ]
        if !notes.isEmpty {
            lines.append("    <desc>\(notes.xmlEscaped)</desc>")
        }
        lines.append("    <trkseg>")
        let df = ISO8601DateFormatter()
        for (i, coord) in routeCoordinates.enumerated() {
            let elapsed = routeCoordinates.count > 1
                ? Double(i) * Double(durationSeconds) / Double(routeCoordinates.count - 1)
                : 0
            let timeStr = df.string(from: date.addingTimeInterval(elapsed))
            let ele = String(format: "%.1f", coord.elevationFt / 3.28084)
            lines += [
                "      <trkpt lat=\"\(coord.latitude)\" lon=\"\(coord.longitude)\">",
                "        <ele>\(ele)</ele>",
                "        <time>\(timeStr)</time>",
                "      </trkpt>"
            ]
        }
        lines += ["    </trkseg>", "  </trk>", "</gpx>"]
        return writeGPX(lines.joined(separator: "\n"), filename: name)
    }
}

// MARK: - HikeStore

class HikeStore: ObservableObject {
    @Published private(set) var completedHikes: [CompletedHike] = []
    @Published var followRoute: HikeRoute?

    private let storageKey = "urban_hike_completed"

    init() { load() }

    // MARK: Computed Stats

    var totalHikes: Int { completedHikes.count }

    var totalMiles: Double {
        completedHikes.map(\.distanceMiles).reduce(0, +)
    }

    var totalElevationFt: Double {
        completedHikes.map(\.elevationGainFt).reduce(0, +)
    }

    var totalFloorsClimbed: Int {
        completedHikes.map(\.floorsAscended).reduce(0, +)
    }

    var totalSteps: Int {
        completedHikes.map(\.steps).reduce(0, +)
    }

    var currentStreak: Int {
        guard !completedHikes.isEmpty else { return 0 }
        let calendar = Calendar.current
        let sorted = completedHikes.sorted { $0.date > $1.date }
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())

        for hike in sorted {
            let hikeDay = calendar.startOfDay(for: hike.date)
            if hikeDay == checkDate {
                if streak == 0 { streak = 1 }
            } else if let prev = calendar.date(byAdding: .day, value: -1, to: checkDate),
                      hikeDay == prev {
                streak += 1
                checkDate = prev
            } else {
                break
            }
        }
        return streak
    }

    var recentHikes: [CompletedHike] {
        Array(completedHikes.prefix(10))
    }

    // MARK: Mutations

    func add(from session: HikeSession, floorsAscended: Int, steps: Int) {
        let coords = session.locations.map {
            RouteCoordinate(
                latitude: $0.coordinate.latitude,
                longitude: $0.coordinate.longitude,
                elevationFt: $0.altitude * 3.28084
            )
        }

        let hike = CompletedHike(
            id: UUID(),
            name: session.name,
            date: session.startTime,
            distanceMiles: session.distanceMiles,
            elevationGainFt: session.elevationGainFt,
            durationSeconds: Int((session.endTime ?? Date()).timeIntervalSince(session.startTime)),
            floorsAscended: floorsAscended,
            steps: steps,
            mode: session.mode,
            routeCoordinates: coords,
            mapSnapshotData: nil
        )

        completedHikes.insert(hike, at: 0)
        save()

        // Generate map snapshot asynchronously and patch it in
        let clCoords = coords.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        Task { @MainActor in
            if let data = await Self.generateSnapshot(for: clCoords) {
                if let idx = completedHikes.firstIndex(where: { $0.id == hike.id }) {
                    completedHikes[idx].mapSnapshotData = data
                    save()
                }
            }
        }
    }

    func delete(at offsets: IndexSet) {
        completedHikes.remove(atOffsets: offsets)
        save()
    }

    func updateNotes(_ notes: String, for hikeID: UUID) {
        guard let idx = completedHikes.firstIndex(where: { $0.id == hikeID }) else { return }
        completedHikes[idx].notes = notes
        save()
    }

    // MARK: - Map Snapshot

    static func generateSnapshot(for coordinates: [CLLocationCoordinate2D]) async -> Data? {
        guard coordinates.count > 1 else { return nil }

        let lats = coordinates.map(\.latitude)
        let lons = coordinates.map(\.longitude)
        let latPad = ((lats.max()! - lats.min()!) * 0.4).magnitude
        let lonPad = ((lons.max()! - lons.min()!) * 0.4).magnitude

        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude:  (lats.min()! + lats.max()!) / 2,
                longitude: (lons.min()! + lons.max()!) / 2
            ),
            span: MKCoordinateSpan(
                latitudeDelta:  max(lats.max()! - lats.min()! + latPad * 2, 0.005),
                longitudeDelta: max(lons.max()! - lons.min()! + lonPad * 2, 0.005)
            )
        )

        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size   = CGSize(width: 360, height: 200)
        options.scale  = 2
        options.mapType = .standard

        do {
            let snapshot = try await MKMapSnapshotter(options: options).start()

            let renderer = UIGraphicsImageRenderer(size: options.size)
            let final = renderer.image { ctx in
                snapshot.image.draw(at: .zero)

                // Dim the basemap slightly so the route pops
                UIColor.black.withAlphaComponent(0.15).setFill()
                ctx.fill(CGRect(origin: .zero, size: options.size))

                // Route polyline
                let path = UIBezierPath()
                path.lineCapStyle  = .round
                path.lineJoinStyle = .round

                for (i, coord) in coordinates.enumerated() {
                    let pt = snapshot.point(for: coord)
                    if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
                }

                // Glow pass
                UIColor.orange.withAlphaComponent(0.35).setStroke()
                path.lineWidth = 8
                path.stroke()

                // Main line
                UIColor.orange.setStroke()
                path.lineWidth = 3.5
                path.stroke()

                // Start dot (green)
                if let first = coordinates.first {
                    let pt = snapshot.point(for: first)
                    UIColor.systemGreen.setFill()
                    UIBezierPath(arcCenter: pt, radius: 5, startAngle: 0, endAngle: .pi * 2, clockwise: true).fill()
                    UIColor.white.setStroke()
                    let ring = UIBezierPath(arcCenter: pt, radius: 5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                    ring.lineWidth = 1.5
                    ring.stroke()
                }

                // End dot (orange)
                if let last = coordinates.last {
                    let pt = snapshot.point(for: last)
                    UIColor.orange.setFill()
                    UIBezierPath(arcCenter: pt, radius: 5, startAngle: 0, endAngle: .pi * 2, clockwise: true).fill()
                    UIColor.white.setStroke()
                    let ring = UIBezierPath(arcCenter: pt, radius: 5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                    ring.lineWidth = 1.5
                    ring.stroke()
                }
            }

            return final.jpegData(compressionQuality: 0.75)
        } catch {
            return nil
        }
    }

    // MARK: Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(completedHikes) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let hikes = try? JSONDecoder().decode([CompletedHike].self, from: data)
        else { return }
        completedHikes = hikes
    }
}

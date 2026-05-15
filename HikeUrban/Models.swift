import Foundation
import CoreLocation
import SwiftUI

// MARK: - Route Mode

enum RouteMode: String, Codable, CaseIterable, Identifiable {
    case walk    = "Walk"
    case hike    = "Hike"
    case run     = "Run"
    case bike    = "Bike"
    case scooter = "Scooter"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .walk:    return "figure.walk"
        case .hike:    return "figure.hiking"
        case .run:     return "figure.run"
        case .bike:    return "bicycle"
        case .scooter: return "scooter"
        }
    }

    var speedMph: Double {
        switch self {
        case .walk:    return 3.0
        case .hike:    return 2.5
        case .run:     return 6.0
        case .bike:    return 12.0
        case .scooter: return 10.0
        }
    }
}

// MARK: - Accessibility

struct AccessibilityInfo: Codable {
    var isWheelchairFriendly: Bool
    var isStrollerFriendly: Bool
    var isLowImpact: Bool
    var hasStairSections: Int
    var surfaceType: SurfaceType
    var maxGradePercent: Double
    var notes: String

    enum SurfaceType: String, Codable, CaseIterable {
        case paved   = "Paved"
        case gravel  = "Gravel"
        case mixed   = "Mixed"
        case unpaved = "Unpaved"
    }

    var accessibilityBadges: [String] {
        var badges: [String] = []
        if isWheelchairFriendly { badges.append("♿️ Wheelchair") }
        if isStrollerFriendly   { badges.append("🍼 Stroller") }
        if isLowImpact          { badges.append("🦯 Low Impact") }
        return badges
    }
}

// MARK: - Photography

struct ShotPin: Identifiable, Codable {
    let id: UUID
    var title: String
    var shootingNotes: String
    var coordinate: RouteCoordinate
    var bestTimeOfDay: TimeOfDay
    var suggestedFocalLength: String
    var tags: [ShotTag]

    enum TimeOfDay: String, Codable, CaseIterable {
        case goldenHourMorning = "Golden Hour AM"
        case goldenHourEvening = "Golden Hour PM"
        case bluehour          = "Blue Hour"
        case midday            = "Midday"
        case night             = "Night"
        case anytime           = "Any Time"

        var icon: String {
            switch self {
            case .goldenHourMorning: return "sunrise.fill"
            case .goldenHourEvening: return "sunset.fill"
            case .bluehour:          return "moon.haze.fill"
            case .midday:            return "sun.max.fill"
            case .night:             return "moon.stars.fill"
            case .anytime:           return "clock"
            }
        }
    }

    enum ShotTag: String, Codable, CaseIterable {
        case architecture = "Architecture"
        case streetArt    = "Street Art"
        case nature       = "Nature"
        case industrial   = "Industrial"
        case portrait     = "Portrait"
        case water        = "Water"
        case abstract     = "Abstract"
    }

    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

// MARK: - Historical Points

struct HistoricalPoint: Identifiable, Codable {
    let id: UUID
    var title: String
    var era: String
    var description: String
    var coordinate: RouteCoordinate
    var audioURL: String?

    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

// MARK: - Dark Safety

struct DarkSafetyRating: Codable {
    var overallScore: Int       // 1–5
    var lightingQuality: Int    // 1–5
    var footTraffic: Int        // 1–5
    var communityNotes: String
    var recommendedAfterDark: Bool
}

// MARK: - HikeRoute

struct HikeRoute: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var neighborhood: String
    var difficulty: Difficulty
    var supportedModes: [RouteMode]
    var coordinates: [RouteCoordinate]
    var distanceMiles: Double
    var elevationGainFt: Double
    var estimatedMinutes: Int
    var rating: Double
    var reviewCount: Int
    var isEditorsPick: Bool
    var tags: [String]
    var accessibility: AccessibilityInfo
    var shotPins: [ShotPin]
    var historicalPoints: [HistoricalPoint]
    var darkSafety: DarkSafetyRating

    enum Difficulty: String, Codable, CaseIterable {
        case easy     = "Easy"
        case moderate = "Moderate"
        case hard     = "Hard"

        var emoji: String {
            switch self {
            case .easy:     return "🟢"
            case .moderate: return "🟡"
            case .hard:     return "🔴"
            }
        }
    }

    var clCoordinates: [CLLocationCoordinate2D] {
        coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    var centerCoordinate: CLLocationCoordinate2D {
        guard !coordinates.isEmpty else {
            return CLLocationCoordinate2D(latitude: 42.3314, longitude: -83.0458)
        }
        let avgLat = coordinates.map(\.latitude).reduce(0, +) / Double(coordinates.count)
        let avgLon = coordinates.map(\.longitude).reduce(0, +) / Double(coordinates.count)
        return CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon)
    }

    func estimatedMinutes(for mode: RouteMode) -> Int {
        Int(distanceMiles / mode.speedMph * 60)
    }
}

struct RouteCoordinate: Codable {
    let latitude: Double
    let longitude: Double
    let elevationFt: Double
}

// MARK: - Walkable Neighbourhood (city-agnostic)

struct WalkableNeighborhood: Identifiable {
    let id = UUID()
    let name: String
    let walkScore: Int
    let coordinates: [CLLocationCoordinate2D]
    let highlights: [String]
    let notes: String

    var center: CLLocationCoordinate2D {
        let lat = coordinates.map(\.latitude).reduce(0, +) / Double(coordinates.count)
        let lon = coordinates.map(\.longitude).reduce(0, +) / Double(coordinates.count)
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    var walkabilityColor: Color {
        switch walkScore {
        case 80...100: return .green
        case 60...79:  return .yellow
        case 40...59:  return .orange
        default:       return .red
        }
    }

    var walkabilityLabel: String {
        switch walkScore {
        case 80...100: return "Walker's Paradise"
        case 60...79:  return "Very Walkable"
        case 40...59:  return "Walkable"
        default:       return "Car-Dependent"
        }
    }

    var walkabilityEmoji: String {
        switch walkScore {
        case 80...100: return "🟢"
        case 60...79:  return "🟡"
        case 40...59:  return "🟠"
        default:       return "🔴"
        }
    }
}

// MARK: - Featured City

struct FeaturedCity: Identifiable {
    let id: String
    let name: String
    let state: String
    let emoji: String
    let tagline: String
    let center: CLLocationCoordinate2D
    var routes: [HikeRoute]
    let neighborhoods: [WalkableNeighborhood]
    var isUserCreated: Bool = false
}

// MARK: - FeaturedCity Codable (custom: CLLocationCoordinate2D isn't Codable)

extension FeaturedCity: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, name, state, emoji, tagline, lat, lon, routes, neighborhoods, isUserCreated
    }

    init(from decoder: Decoder) throws {
        let c     = try decoder.container(keyedBy: CodingKeys.self)
        id            = try c.decode(String.self,               forKey: .id)
        name          = try c.decode(String.self,               forKey: .name)
        state         = try c.decode(String.self,               forKey: .state)
        emoji         = try c.decode(String.self,               forKey: .emoji)
        tagline       = try c.decode(String.self,               forKey: .tagline)
        let lat       = try c.decode(Double.self,               forKey: .lat)
        let lon       = try c.decode(Double.self,               forKey: .lon)
        center        = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        routes        = try c.decode([HikeRoute].self,          forKey: .routes)
        neighborhoods = try c.decode([WalkableNeighborhood].self, forKey: .neighborhoods)
        isUserCreated = try c.decodeIfPresent(Bool.self,        forKey: .isUserCreated) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id,                 forKey: .id)
        try c.encode(name,               forKey: .name)
        try c.encode(state,              forKey: .state)
        try c.encode(emoji,              forKey: .emoji)
        try c.encode(tagline,            forKey: .tagline)
        try c.encode(center.latitude,    forKey: .lat)
        try c.encode(center.longitude,   forKey: .lon)
        try c.encode(routes,             forKey: .routes)
        try c.encode(neighborhoods,      forKey: .neighborhoods)
        try c.encode(isUserCreated,      forKey: .isUserCreated)
    }
}

// MARK: - WalkableNeighborhood Codable (custom: stores coordinates as [[Double]])

extension WalkableNeighborhood: Codable {
    private enum CodingKeys: String, CodingKey { case name, walkScore, coordinatePairs, highlights, notes }

    init(from decoder: Decoder) throws {
        let c      = try decoder.container(keyedBy: CodingKeys.self)
        name       = try c.decode(String.self,    forKey: .name)
        walkScore  = try c.decode(Int.self,        forKey: .walkScore)
        highlights = try c.decode([String].self,  forKey: .highlights)
        notes      = try c.decode(String.self,    forKey: .notes)
        let pairs  = try c.decode([[Double]].self, forKey: .coordinatePairs)
        coordinates = pairs.map { CLLocationCoordinate2D(latitude: $0[0], longitude: $0[1]) }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name,       forKey: .name)
        try c.encode(walkScore,  forKey: .walkScore)
        try c.encode(highlights, forKey: .highlights)
        try c.encode(notes,      forKey: .notes)
        let pairs = coordinates.map { [$0.latitude, $0.longitude] }
        try c.encode(pairs,      forKey: .coordinatePairs)
    }
}

// MARK: - GPX export helpers (shared)

extension String {
    var xmlEscaped: String {
        self.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}

func writeGPX(_ content: String, filename: String) -> URL? {
    let safe = filename
        .replacingOccurrences(of: "/", with: "-")
        .replacingOccurrences(of: ":", with: "-")
    let url = FileManager.default.temporaryDirectory
        .appendingPathComponent(safe + ".gpx")
    do {
        try content.write(to: url, atomically: true, encoding: .utf8)
        return url
    } catch {
        return nil
    }
}

// MARK: - HikeRoute GPX export

extension HikeRoute {
    // snapped: road-accurate coordinates from MKDirections. When provided these are
    // used for geometry (many points, no elevation). Falls back to raw waypoints with
    // elevation when snapped coords aren't available yet.
    func gpxFileURL(snapped: [CLLocationCoordinate2D]? = nil) -> URL? {
        var lines = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<gpx version=\"1.1\" creator=\"HikeUrban\" xmlns=\"http://www.topografix.com/GPX/1/1\">",
            "  <trk>",
            "    <name>\(name.xmlEscaped)</name>"
        ]
        if !description.isEmpty {
            lines.append("    <desc>\(description.xmlEscaped)</desc>")
        }
        lines.append("    <trkseg>")
        if let snapped = snapped {
            for coord in snapped {
                lines += [
                    "      <trkpt lat=\"\(coord.latitude)\" lon=\"\(coord.longitude)\">",
                    "      </trkpt>"
                ]
            }
        } else {
            for coord in coordinates {
                let ele = String(format: "%.1f", coord.elevationFt / 3.28084)
                lines += [
                    "      <trkpt lat=\"\(coord.latitude)\" lon=\"\(coord.longitude)\">",
                    "        <ele>\(ele)</ele>",
                    "      </trkpt>"
                ]
            }
        }
        lines += ["    </trkseg>", "  </trk>", "</gpx>"]
        return writeGPX(lines.joined(separator: "\n"), filename: name)
    }
}

// MARK: - HikeRoute factory for user-drawn routes

extension HikeRoute {
    static func userCreated(
        name: String,
        coordinates: [CLLocationCoordinate2D],
        distanceMiles: Double,
        difficulty: Difficulty,
        supportedModes: [RouteMode]
    ) -> HikeRoute {
        HikeRoute(
            id: UUID(),
            name: name,
            description: "",
            neighborhood: "My Route",
            difficulty: difficulty,
            supportedModes: supportedModes,
            coordinates: coordinates.map {
                RouteCoordinate(latitude: $0.latitude, longitude: $0.longitude, elevationFt: 0)
            },
            distanceMiles: distanceMiles,
            elevationGainFt: 0,
            estimatedMinutes: max(1, Int(distanceMiles / 3.0 * 60)),
            rating: 0,
            reviewCount: 0,
            isEditorsPick: false,
            tags: [],
            accessibility: AccessibilityInfo(
                isWheelchairFriendly: false,
                isStrollerFriendly: false,
                isLowImpact: false,
                hasStairSections: 0,
                surfaceType: .mixed,
                maxGradePercent: 0,
                notes: ""
            ),
            shotPins: [],
            historicalPoints: [],
            darkSafety: DarkSafetyRating(
                overallScore: 3,
                lightingQuality: 3,
                footTraffic: 3,
                communityNotes: "",
                recommendedAfterDark: false
            )
        )
    }
}

// MARK: - Live Session

struct HikeSession: Identifiable {
    let id = UUID()
    var name: String = "New Hike"
    var mode: RouteMode = .walk
    var startTime: Date = Date()
    var endTime: Date?
    var locations: [CLLocation] = []
    var floorsAscended: Int = 0

    var distanceMiles: Double {
        guard locations.count > 1 else { return 0 }
        var total = 0.0
        for i in 1..<locations.count {
            total += locations[i].distance(from: locations[i - 1])
        }
        return total / 1609.34
    }

    var elevationGainFt: Double {
        guard locations.count > 1 else { return 0 }
        var gain = 0.0
        for i in 1..<locations.count {
            let diff = locations[i].altitude - locations[i - 1].altitude
            if diff > 0 { gain += diff }
        }
        return gain * 3.28084
    }

    var durationFormatted: String {
        let elapsed = Int((endTime ?? Date()).timeIntervalSince(startTime))
        let h = elapsed / 3600
        let m = (elapsed % 3600) / 60
        let s = elapsed % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, s)
                     : String(format: "%d:%02d", m, s)
    }
}

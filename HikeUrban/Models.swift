import Foundation
import CoreLocation

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

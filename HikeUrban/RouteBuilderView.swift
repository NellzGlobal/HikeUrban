import SwiftUI
import MapKit

// MARK: - Route Builder View

struct RouteBuilderView: View {
    @State private var mode: BuilderMode = .draw
    @State private var waypoints: [CLLocationCoordinate2D] = []
    @State private var routeName = ""
    @State private var selectedDifficulty: HikeRoute.Difficulty = .easy
    @State private var selectedModes: Set<RouteMode> = [.walk]
    @State private var showSaveSheet = false
    @State private var showSavedConfirmation = false
    @State private var selectedNeighborhood: DetroitNeighborhood?
    @State private var showNeighborhoodDetail = false

    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 42.3505, longitude: -83.0558),
            span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
        )
    )

    enum BuilderMode: String, CaseIterable {
        case draw          = "Draw Route"
        case neighborhoods = "Neighbourhoods"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // MARK: Mode Picker
                Picker("Mode", selection: $mode) {
                    ForEach(BuilderMode.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)

                // MARK: Map
                ZStack(alignment: .bottomTrailing) {
                    MapReader { proxy in
                        Map(position: $position) {
                            if mode == .draw {
                                ForEach(Array(waypoints.enumerated()), id: \.offset) { index, coord in
                                    Annotation(index == 0 ? "Start" : "\(index + 1)", coordinate: coord) {
                                        ZStack {
                                            Circle()
                                                .fill(index == 0 ? Color.green : Color.orange)
                                                .frame(width: 28, height: 28)
                                            Text(index == 0 ? "S" : "\(index + 1)")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                        .shadow(radius: 2)
                                    }
                                }
                                if waypoints.count > 1 {
                                    MapPolyline(coordinates: waypoints)
                                        .stroke(Color.orange, lineWidth: 3)
                                }
                            }

                            if mode == .neighborhoods {
                                ForEach(DetroitNeighborhood.all) { hood in
                                    MapPolygon(coordinates: hood.coordinates)
                                        .foregroundStyle(
                                            hood.walkabilityColor.opacity(
                                                selectedNeighborhood?.id == hood.id ? 0.5 : 0.25
                                            )
                                        )
                                        .stroke(hood.walkabilityColor, lineWidth: 1.5)

                                    Annotation(hood.name, coordinate: hood.center) {
                                        Button {
                                            selectedNeighborhood = hood
                                            showNeighborhoodDetail = true
                                        } label: {
                                            VStack(spacing: 2) {
                                                Text(hood.walkabilityEmoji)
                                                    .font(.title3)
                                                Text(hood.name)
                                                    .font(.system(size: 9, weight: .semibold))
                                                    .foregroundColor(.primary)
                                                    .padding(.horizontal, 4)
                                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 4))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .onTapGesture { screenPoint in
                            guard mode == .draw else { return }
                            if let coord = proxy.convert(screenPoint, from: .local) {
                                waypoints.append(coord)
                            }
                        }
                    }

                    // Draw mode floating controls
                    if mode == .draw && !waypoints.isEmpty {
                        VStack(spacing: 10) {
                            Button {
                                waypoints.removeLast()
                            } label: {
                                Image(systemName: "arrow.uturn.backward")
                                    .mapControlButton(color: .primary, bg: Color(.systemBackground))
                            }

                            Button {
                                waypoints.removeAll()
                            } label: {
                                Image(systemName: "trash")
                                    .mapControlButton(color: .red, bg: Color(.systemBackground))
                            }
                        }
                        .padding(.trailing, 12)
                        .padding(.bottom, 16)
                    }
                }
                .frame(maxHeight: .infinity)

                // MARK: Bottom Panel
                if mode == .draw {
                    DrawBottomPanel(
                        waypointCount: waypoints.count,
                        distance: estimatedDistance,
                        onSave: { showSaveSheet = true }
                    )
                } else {
                    NeighbourhoodLegend()
                }
            }
            .navigationTitle(mode == .draw ? "Draw a Route" : "Walkable Detroit")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSaveSheet) {
                SaveRouteSheet(
                    waypoints: waypoints,
                    routeName: $routeName,
                    difficulty: $selectedDifficulty,
                    modes: $selectedModes,
                    estimatedDistance: estimatedDistance,
                    onSave: {
                        showSavedConfirmation = true
                        waypoints.removeAll()
                    }
                )
            }
            .sheet(isPresented: $showNeighborhoodDetail) {
                if let hood = selectedNeighborhood {
                    NeighbourhoodDetailSheet(neighbourhood: hood)
                }
            }
            .overlay(alignment: .top) {
                if showSavedConfirmation {
                    ConfirmationBanner(message: "Route saved!")
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSavedConfirmation = false
                            }
                        }
                }
            }
        }
    }

    private var estimatedDistance: Double {
        guard waypoints.count > 1 else { return 0 }
        var total = 0.0
        for i in 1..<waypoints.count {
            let a = CLLocation(latitude: waypoints[i-1].latitude, longitude: waypoints[i-1].longitude)
            let b = CLLocation(latitude: waypoints[i].latitude, longitude: waypoints[i].longitude)
            total += b.distance(from: a)
        }
        return total / 1609.34
    }
}

// MARK: - Map Control Button Style

extension Image {
    func mapControlButton(color: Color, bg: Color) -> some View {
        self
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(color)
            .frame(width: 40, height: 40)
            .background(bg)
            .clipShape(Circle())
            .shadow(radius: 3)
    }
}

// MARK: - Draw Bottom Panel

struct DrawBottomPanel: View {
    let waypointCount: Int
    let distance: Double
    let onSave: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            if waypointCount == 0 {
                HStack {
                    Image(systemName: "hand.tap")
                        .foregroundColor(.orange)
                    Text("Tap the map to start drawing your route")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                HStack(spacing: 24) {
                    VStack(spacing: 2) {
                        Text("\(waypointCount)")
                            .font(.title2).fontWeight(.bold)
                        Text("points")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    VStack(spacing: 2) {
                        Text(String(format: "%.2f", distance))
                            .font(.title2).fontWeight(.bold)
                        Text("miles")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: onSave) {
                        Label("Save Route", systemImage: "checkmark.circle.fill")
                            .font(.subheadline).fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(waypointCount < 2 ? Color.gray : Color.orange)
                            .cornerRadius(10)
                    }
                    .disabled(waypointCount < 2)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(radius: 4)
    }
}

// MARK: - Save Route Sheet

struct SaveRouteSheet: View {
    let waypoints: [CLLocationCoordinate2D]
    @Binding var routeName: String
    @Binding var difficulty: HikeRoute.Difficulty
    @Binding var modes: Set<RouteMode>
    let estimatedDistance: Double
    let onSave: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Route Name") {
                    TextField("e.g. My Corktown Loop", text: $routeName)
                }

                Section("Details") {
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(HikeRoute.Difficulty.allCases, id: \.self) { d in
                            Text("\(d.emoji) \(d.rawValue)").tag(d)
                        }
                    }
                    LabeledContent("Distance", value: String(format: "%.2f miles", estimatedDistance))
                    LabeledContent("Waypoints", value: "\(waypoints.count)")
                }

                Section("Supported Modes") {
                    ForEach(RouteMode.allCases) { mode in
                        HStack {
                            Image(systemName: mode.icon)
                                .foregroundColor(.orange)
                                .frame(width: 24)
                            Text(mode.rawValue)
                            Spacer()
                            if modes.contains(mode) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.orange)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if modes.contains(mode) { modes.remove(mode) }
                            else { modes.insert(mode) }
                        }
                    }
                }
            }
            .navigationTitle("Save Route")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(routeName.isEmpty || modes.isEmpty)
                }
            }
        }
    }
}

// MARK: - Detroit Neighbourhood Data

struct DetroitNeighborhood: Identifiable {
    let id = UUID()
    let name: String
    let walkScore: Int
    let coordinates: [CLLocationCoordinate2D]
    let highlights: [String]
    let notes: String

    var center: CLLocationCoordinate2D {
        let lat = coordinates.map(\.latitude).reduce(0, +)  / Double(coordinates.count)
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

    static let all: [DetroitNeighborhood] = [
        DetroitNeighborhood(
            name: "Downtown", walkScore: 92,
            coordinates: [
                CLLocationCoordinate2D(latitude: 42.3400, longitude: -83.0580),
                CLLocationCoordinate2D(latitude: 42.3400, longitude: -83.0290),
                CLLocationCoordinate2D(latitude: 42.3280, longitude: -83.0290),
                CLLocationCoordinate2D(latitude: 42.3280, longitude: -83.0580),
            ],
            highlights: ["Hart Plaza", "Campus Martius", "Riverfront", "Woodward Ave"],
            notes: "Detroit's most walkable area. Dense retail, dining, riverfront access, and major transit hub."
        ),
        DetroitNeighborhood(
            name: "Midtown", walkScore: 85,
            coordinates: [
                CLLocationCoordinate2D(latitude: 42.3720, longitude: -83.0780),
                CLLocationCoordinate2D(latitude: 42.3720, longitude: -83.0540),
                CLLocationCoordinate2D(latitude: 42.3480, longitude: -83.0540),
                CLLocationCoordinate2D(latitude: 42.3480, longitude: -83.0780),
            ],
            highlights: ["DIA", "Wayne State", "MOCAD", "Cass Corridor"],
            notes: "Arts, culture, and student energy. Well-connected grid with good lighting and foot traffic."
        ),
        DetroitNeighborhood(
            name: "Corktown", walkScore: 78,
            coordinates: [
                CLLocationCoordinate2D(latitude: 42.3390, longitude: -83.0850),
                CLLocationCoordinate2D(latitude: 42.3390, longitude: -83.0640),
                CLLocationCoordinate2D(latitude: 42.3260, longitude: -83.0640),
                CLLocationCoordinate2D(latitude: 42.3260, longitude: -83.0850),
            ],
            highlights: ["Michigan Central Station", "Roosevelt Park", "Michigan Ave dining"],
            notes: "Detroit's oldest neighbourhood is booming. Tight grid of brick streets, great cafes, Ford's new campus."
        ),
        DetroitNeighborhood(
            name: "Eastern Market", walkScore: 81,
            coordinates: [
                CLLocationCoordinate2D(latitude: 42.3560, longitude: -83.0470),
                CLLocationCoordinate2D(latitude: 42.3560, longitude: -83.0290),
                CLLocationCoordinate2D(latitude: 42.3420, longitude: -83.0290),
                CLLocationCoordinate2D(latitude: 42.3420, longitude: -83.0470),
            ],
            highlights: ["Shed 5 murals", "Saturday market", "Gratiot corridor"],
            notes: "One of Detroit's most vibrant daytime walkable areas. Best on Saturday when the market is running."
        ),
        DetroitNeighborhood(
            name: "Rivertown", walkScore: 74,
            coordinates: [
                CLLocationCoordinate2D(latitude: 42.3360, longitude: -83.0290),
                CLLocationCoordinate2D(latitude: 42.3360, longitude: -83.0130),
                CLLocationCoordinate2D(latitude: 42.3270, longitude: -83.0130),
                CLLocationCoordinate2D(latitude: 42.3270, longitude: -83.0290),
            ],
            highlights: ["Riverwalk east extension", "Dequindre Cut south end", "Whiskey Island"],
            notes: "A quieter stretch of the Riverwalk east of Downtown. Great for evening walks with river views."
        ),
        DetroitNeighborhood(
            name: "New Center", walkScore: 63,
            coordinates: [
                CLLocationCoordinate2D(latitude: 42.3860, longitude: -83.0960),
                CLLocationCoordinate2D(latitude: 42.3860, longitude: -83.0720),
                CLLocationCoordinate2D(latitude: 42.3700, longitude: -83.0720),
                CLLocationCoordinate2D(latitude: 42.3700, longitude: -83.0960),
            ],
            highlights: ["Fisher Building", "GM Renaissance Center (nearby)", "Grand Boulevard"],
            notes: "Grand architecture with Albert Kahn buildings throughout. Walkable on main corridors."
        ),
        DetroitNeighborhood(
            name: "Greektown", walkScore: 88,
            coordinates: [
                CLLocationCoordinate2D(latitude: 42.3380, longitude: -83.0430),
                CLLocationCoordinate2D(latitude: 42.3380, longitude: -83.0280),
                CLLocationCoordinate2D(latitude: 42.3290, longitude: -83.0280),
                CLLocationCoordinate2D(latitude: 42.3290, longitude: -83.0430),
            ],
            highlights: ["Monroe Street", "Bricktown", "Little Caesars Arena nearby"],
            notes: "Entertainment district with dense restaurants and nightlife. Very walkable evenings and weekends."
        ),
        DetroitNeighborhood(
            name: "Mexicantown", walkScore: 66,
            coordinates: [
                CLLocationCoordinate2D(latitude: 42.3270, longitude: -83.1050),
                CLLocationCoordinate2D(latitude: 42.3270, longitude: -83.0870),
                CLLocationCoordinate2D(latitude: 42.3170, longitude: -83.0870),
                CLLocationCoordinate2D(latitude: 42.3170, longitude: -83.1050),
            ],
            highlights: ["Vernor Highway restaurants", "Patton Park", "Ambassador Bridge views"],
            notes: "Authentic neighbourhood with great food and culture. Walk score limited by distance from core."
        ),
    ]
}

// MARK: - Neighbourhood Legend

struct NeighbourhoodLegend: View {
    var body: some View {
        HStack(spacing: 16) {
            ForEach([("🟢", "80+"), ("🟡", "60-79"), ("🟠", "40-59"), ("🔴", "<40")], id: \.0) { emoji, label in
                HStack(spacing: 4) {
                    Text(emoji).font(.caption)
                    Text(label).font(.caption2).foregroundColor(.secondary)
                }
            }
            Spacer()
            Text("Walk Score")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .shadow(radius: 2)
    }
}

// MARK: - Neighbourhood Detail Sheet

struct NeighbourhoodDetailSheet: View {
    let neighbourhood: DetroitNeighborhood
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    HStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .stroke(neighbourhood.walkabilityColor, lineWidth: 6)
                                .frame(width: 90, height: 90)
                            VStack(spacing: 0) {
                                Text("\(neighbourhood.walkScore)")
                                    .font(.largeTitle).fontWeight(.bold)
                                Text("/ 100")
                                    .font(.caption).foregroundColor(.secondary)
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(neighbourhood.name)
                                .font(.title2).fontWeight(.bold)
                            Text(neighbourhood.walkabilityLabel)
                                .font(.subheadline)
                                .foregroundColor(neighbourhood.walkabilityColor)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.horizontal)

                    Text(neighbourhood.notes)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Highlights")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(neighbourhood.highlights, id: \.self) { item in
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.orange)
                                Text(item).font(.subheadline)
                            }
                            .padding(.horizontal)
                        }
                    }

                    Map {
                        MapPolygon(coordinates: neighbourhood.coordinates)
                            .foregroundStyle(neighbourhood.walkabilityColor.opacity(0.3))
                            .stroke(neighbourhood.walkabilityColor, lineWidth: 2)
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)

                    Spacer(minLength: 24)
                }
                .padding(.top)
            }
            .navigationTitle(neighbourhood.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Confirmation Banner

struct ConfirmationBanner: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline).fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.green)
            .cornerRadius(20)
            .shadow(radius: 4)
            .padding(.top, 8)
            .transition(.move(edge: .top).combined(with: .opacity))
    }
}

import SwiftUI
import MapKit

// MARK: - Route Builder View

struct RouteBuilderView: View {
    @EnvironmentObject var cityStore: CityStore
    @State private var mode: BuilderMode = .draw
    @State private var waypoints: [CLLocationCoordinate2D] = []
    @State private var snappedCoords: [CLLocationCoordinate2D] = []   // road-following path
    @State private var segmentLengths: [Int] = []                     // coords per segment for undo
    @State private var isSnapping = false
    @State private var routeName = ""
    @State private var selectedDifficulty: HikeRoute.Difficulty = .easy
    @State private var selectedModes: Set<RouteMode> = [.walk]
    @State private var showSaveSheet = false
    @State private var showSavedConfirmation = false
    @State private var selectedNeighborhood: WalkableNeighborhood?
    @State private var showNeighborhoodDetail = false

    @State private var position: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)

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
                                if snappedCoords.count > 1 {
                                    MapPolyline(coordinates: snappedCoords)
                                        .stroke(Color.orange, lineWidth: 3)
                                }
                            }

                            if mode == .neighborhoods {
                                ForEach(cityStore.selectedCity.neighborhoods) { hood in
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
                            guard mode == .draw, !isSnapping else { return }
                            if let coord = proxy.convert(screenPoint, from: .local) {
                                if waypoints.isEmpty {
                                    waypoints.append(coord)
                                    snappedCoords.append(coord)
                                } else {
                                    let from = waypoints.last!
                                    waypoints.append(coord)
                                    Task { await snapSegment(from: from, to: coord) }
                                }
                            }
                        }
                    }

                    // Draw mode floating controls
                    if mode == .draw && !waypoints.isEmpty {
                        VStack(spacing: 10) {
                            if isSnapping {
                                ProgressView()
                                    .frame(width: 40, height: 40)
                                    .background(Color(.systemBackground))
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                            } else {
                                Button {
                                    waypoints.removeLast()
                                    if waypoints.isEmpty {
                                        snappedCoords.removeAll()
                                        segmentLengths.removeAll()
                                    } else if let last = segmentLengths.last {
                                        snappedCoords.removeLast(last)
                                        segmentLengths.removeLast()
                                    }
                                } label: {
                                    Image(systemName: "arrow.uturn.backward")
                                        .mapControlButton(color: .primary, bg: Color(.systemBackground))
                                }

                                Button {
                                    waypoints.removeAll()
                                    snappedCoords.removeAll()
                                    segmentLengths.removeAll()
                                } label: {
                                    Image(systemName: "trash")
                                        .mapControlButton(color: .red, bg: Color(.systemBackground))
                                }
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
                        isSnapping: isSnapping,
                        onSave: { showSaveSheet = true }
                    )
                } else {
                    NeighbourhoodLegend()
                }
            }
            .navigationTitle(mode == .draw ? "Draw a Route" : "\(cityStore.selectedCity.name) Walkability")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSaveSheet) {
                SaveRouteSheet(
                    waypoints: snappedCoords,
                    routeName: $routeName,
                    difficulty: $selectedDifficulty,
                    modes: $selectedModes,
                    estimatedDistance: estimatedDistance,
                    onSave: {
                        let route = HikeRoute.userCreated(
                            name: routeName,
                            coordinates: snappedCoords,
                            distanceMiles: estimatedDistance,
                            difficulty: selectedDifficulty,
                            supportedModes: Array(selectedModes)
                        )
                        cityStore.addRoute(route, toCityWithID: cityStore.selectedCity.id)
                        routeName = ""
                        showSavedConfirmation = true
                        waypoints.removeAll()
                        snappedCoords.removeAll()
                        segmentLengths.removeAll()
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
        guard snappedCoords.count > 1 else { return 0 }
        var total = 0.0
        for i in 1..<snappedCoords.count {
            let a = CLLocation(latitude: snappedCoords[i-1].latitude, longitude: snappedCoords[i-1].longitude)
            let b = CLLocation(latitude: snappedCoords[i].latitude, longitude: snappedCoords[i].longitude)
            total += b.distance(from: a)
        }
        return total / 1609.34
    }

    private func snapSegment(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) async {
        isSnapping = true
        defer { isSnapping = false }

        let request = MKDirections.Request()
        if #available(iOS 26.0, *) {
            request.source      = MKMapItem(location: CLLocation(latitude: start.latitude, longitude: start.longitude), address: nil)
            request.destination = MKMapItem(location: CLLocation(latitude: end.latitude, longitude: end.longitude), address: nil)
        } else {
            request.source      = MKMapItem(placemark: MKPlacemark(coordinate: start))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        }
        request.transportType = .walking
        request.requestsAlternateRoutes = false

        do {
            let response = try await MKDirections(request: request).calculate()
            if let route = response.routes.first {
                var coords = [CLLocationCoordinate2D](repeating: .init(), count: route.polyline.pointCount)
                route.polyline.getCoordinates(&coords, range: NSRange(location: 0, length: route.polyline.pointCount))
                segmentLengths.append(coords.count)
                snappedCoords.append(contentsOf: coords)
            }
        } catch {
            // Fallback: straight line to the tapped point
            segmentLengths.append(1)
            snappedCoords.append(end)
        }
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
    let isSnapping: Bool
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
                        if isSnapping {
                            ProgressView().scaleEffect(0.8)
                        } else {
                            Text(String(format: "%.2f", distance))
                                .font(.title2).fontWeight(.bold)
                        }
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
                            .background(waypointCount < 2 || isSnapping ? Color.gray : Color.orange)
                            .cornerRadius(10)
                    }
                    .disabled(waypointCount < 2 || isSnapping)
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
    let neighbourhood: WalkableNeighborhood
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

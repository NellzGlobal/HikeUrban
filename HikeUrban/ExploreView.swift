import SwiftUI
import MapKit

struct ExploreView: View {
    @EnvironmentObject var cityStore: CityStore
    @State private var selectedMode: RouteMode? = nil
    @State private var showOnlyAccessible  = false
    @State private var showOnlyAfterDark   = false
    @State private var selectedRoute: HikeRoute?
    @State private var showDetail = false
    @State private var snappedPaths: [UUID: [CLLocationCoordinate2D]] = [:]

    @State private var position: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)

    var filteredRoutes: [HikeRoute] {
        cityStore.selectedCity.routes.filter { route in
            let modeMatch   = selectedMode == nil || route.supportedModes.contains(selectedMode!)
            let accessMatch = !showOnlyAccessible  || route.accessibility.isWheelchairFriendly
            let darkMatch   = !showOnlyAfterDark   || route.darkSafety.recommendedAfterDark
            return modeMatch && accessMatch && darkMatch
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // MARK: City Picker
                CityPickerBar()

                // MARK: Map
                Map(position: $position) {
                    ForEach(filteredRoutes) { route in
                        MapPolyline(coordinates: snappedPaths[route.id] ?? route.clCoordinates)
                            .stroke(
                                selectedRoute?.id == route.id ? Color.orange : Color.blue.opacity(0.6),
                                lineWidth: selectedRoute?.id == route.id ? 4 : 2.5
                            )

                        Annotation(route.name, coordinate: route.centerCoordinate) {
                            Button {
                                withAnimation {
                                    selectedRoute = route
                                    zoomTo(route)
                                }
                            } label: {
                                Image(systemName: route.isEditorsPick ? "star.fill" : "figure.hiking")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(7)
                                    .background(selectedRoute?.id == route.id ? Color.orange : Color.blue)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                            }
                        }
                    }
                }
                .frame(height: 260)
                .task(id: cityStore.selectedCity.id) {
                    await snapRoutes(cityStore.selectedCity.routes)
                }

                // MARK: Filter Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {

                        ForEach(RouteMode.allCases) { mode in
                            FilterChip(
                                label: mode.rawValue,
                                icon: mode.icon,
                                isActive: selectedMode == mode
                            ) {
                                selectedMode = selectedMode == mode ? nil : mode
                            }
                        }

                        Divider().frame(height: 24)

                        FilterChip(
                            label: "Accessible",
                            icon: "figure.roll",
                            isActive: showOnlyAccessible
                        ) {
                            showOnlyAccessible.toggle()
                        }

                        FilterChip(
                            label: "After Dark",
                            icon: "moon.stars.fill",
                            isActive: showOnlyAfterDark
                        ) {
                            showOnlyAfterDark.toggle()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemBackground))

                // MARK: Route List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if filteredRoutes.isEmpty {
                            ContentUnavailableView(
                                "No Routes",
                                systemImage: "map",
                                description: Text("No routes match your current filters.")
                            )
                            .padding(.top, 60)
                        } else {
                            ForEach(filteredRoutes) { route in
                                RouteCard(route: route, isSelected: selectedRoute?.id == route.id)
                                    .onTapGesture {
                                        withAnimation { selectedRoute = route; zoomTo(route) }
                                        showDetail = true
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("\(cityStore.selectedCity.name) Routes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            selectedRoute = nil
                            selectedMode = nil
                            showOnlyAccessible = false
                            showOnlyAfterDark = false
                            position = .region(MKCoordinateRegion(
                                center: cityStore.selectedCity.center,
                                span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
                            ))
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            }
            .sheet(isPresented: $showDetail) {
                if let route = selectedRoute {
                    RouteDetailView(route: route)
                }
            }
            .onChange(of: cityStore.selectedCity.id) { _, _ in
                withAnimation {
                    selectedRoute = nil
                    position = .region(MKCoordinateRegion(
                        center: cityStore.selectedCity.center,
                        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
                    ))
                }
            }
        }
    }

    private func zoomTo(_ route: HikeRoute) {
        position = .region(MKCoordinateRegion(
            center: route.centerCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        ))
    }

    private func snapRoutes(_ routes: [HikeRoute]) async {
        for route in routes {
            guard snappedPaths[route.id] == nil else { continue }
            let waypoints = route.clCoordinates
            guard waypoints.count >= 2 else { continue }
            var result: [CLLocationCoordinate2D] = [waypoints[0]]
            for i in 1..<waypoints.count {
                let request = MKDirections.Request()
                if #available(iOS 26.0, *) {
                    request.source      = MKMapItem(location: CLLocation(latitude: waypoints[i-1].latitude, longitude: waypoints[i-1].longitude), address: nil)
                    request.destination = MKMapItem(location: CLLocation(latitude: waypoints[i].latitude,   longitude: waypoints[i].longitude),   address: nil)
                } else {
                    request.source      = MKMapItem(placemark: MKPlacemark(coordinate: waypoints[i-1]))
                    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: waypoints[i]))
                }
                request.transportType = .walking
                request.requestsAlternateRoutes = false
                if let response = try? await MKDirections(request: request).calculate(),
                   let mkRoute = response.routes.first {
                    var coords = [CLLocationCoordinate2D](repeating: .init(), count: mkRoute.polyline.pointCount)
                    mkRoute.polyline.getCoordinates(&coords, range: NSRange(location: 0, length: mkRoute.polyline.pointCount))
                    result.append(contentsOf: coords)
                } else {
                    result.append(waypoints[i])
                }
            }
            snappedPaths[route.id] = result
        }
    }
}

// MARK: - City Picker Bar

struct CityPickerBar: View {
    @EnvironmentObject var cityStore: CityStore
    @State private var showAddCity = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(cityStore.allCities) { city in
                    Button {
                        cityStore.selectedCity = city
                    } label: {
                        HStack(spacing: 4) {
                            Text(city.emoji)
                            Text(city.name)
                            if city.isUserCreated {
                                Image(systemName: "person.fill")
                                    .font(.caption2)
                            }
                        }
                        .font(.subheadline)
                        .fontWeight(cityStore.selectedCity.id == city.id ? .semibold : .regular)
                        .foregroundColor(cityStore.selectedCity.id == city.id ? .white : .primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(cityStore.selectedCity.id == city.id ? Color.orange : Color(.secondarySystemBackground))
                        .cornerRadius(20)
                    }
                    .buttonStyle(.plain)
                }

                Button { showAddCity = true } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Add City")
                    }
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.12))
                    .cornerRadius(20)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $showAddCity) {
            AddCitySheet()
        }
    }
}

// MARK: - Add City Sheet

struct AddCitySheet: View {
    @EnvironmentObject var cityStore: CityStore
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss

    @State private var cityName = ""
    @State private var cityEmoji = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("City Name") {
                    TextField("e.g. Austin, Edinburgh, Cape Town…", text: $cityName)
                }
                Section("Icon (optional)") {
                    TextField("e.g. 🌵  🏙️  🌊", text: $cityEmoji)
                }
                Section {
                    Label(
                        "Your city will be centred on your current GPS location. Draw and save routes from the Route Builder tab — they'll appear here when you select your city.",
                        systemImage: "info.circle"
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Add Your City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let center = locationManager.location?.coordinate
                            ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
                        cityStore.createCity(name: cityName, emoji: cityEmoji, center: center)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(cityName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let label: String
    let icon: String
    let isActive: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                Text(label)
            }
            .font(.caption)
            .fontWeight(isActive ? .semibold : .regular)
            .foregroundColor(isActive ? .white : .primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isActive ? Color.orange : Color(.secondarySystemBackground))
            .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Route Card

struct RouteCard: View {
    let route: HikeRoute
    let isSelected: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {

                HStack(spacing: 6) {
                    Text(route.difficulty.emoji)
                    Text(route.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    if route.isEditorsPick {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    Spacer()
                }

                Text(route.neighborhood)
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 6) {
                    ForEach(route.supportedModes) { mode in
                        Image(systemName: mode.icon)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    ForEach(route.accessibility.accessibilityBadges.prefix(2), id: \.self) { badge in
                        Text(badge.components(separatedBy: " ").first ?? "")
                            .font(.caption2)
                    }
                }

                HStack(spacing: 14) {
                    Label(String(format: "%.1f mi", route.distanceMiles), systemImage: "arrow.left.and.right")
                    Label("\(Int(route.elevationGainFt)) ft", systemImage: "arrow.up.right")
                    Label("\(route.estimatedMinutes) min", systemImage: "clock")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.top, 2)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                    Text(String(format: "%.1f", route.rating))
                        .font(.caption2).fontWeight(.semibold)
                    Text("(\(route.reviewCount))")
                        .font(.caption2).foregroundColor(.secondary)
                    Spacer()
                    if route.darkSafety.recommendedAfterDark {
                        Label("After dark OK", systemImage: "moon.stars.fill")
                            .font(.caption2)
                            .foregroundColor(.indigo)
                    }
                }
                .padding(.top, 2)
            }

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
                .padding(.top, 4)
        }
        .padding()
        .background(isSelected ? Color.orange.opacity(0.08) : Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 1.5)
        )
    }
}

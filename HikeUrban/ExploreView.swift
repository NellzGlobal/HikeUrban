import SwiftUI
import MapKit

struct ExploreView: View {
    @State private var allRoutes    = HikeRoute.detroitSamples
    @State private var selectedMode: RouteMode? = nil
    @State private var showOnlyAccessible  = false
    @State private var showOnlyAfterDark   = false
    @State private var selectedRoute: HikeRoute?
    @State private var showDetail = false

    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 42.3505, longitude: -83.0558),
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        )
    )

    var filteredRoutes: [HikeRoute] {
        allRoutes.filter { route in
            let modeMatch   = selectedMode == nil || route.supportedModes.contains(selectedMode!)
            let accessMatch = !showOnlyAccessible  || route.accessibility.isWheelchairFriendly
            let darkMatch   = !showOnlyAfterDark   || route.darkSafety.recommendedAfterDark
            return modeMatch && accessMatch && darkMatch
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // MARK: Map
                Map(position: $position) {
                    ForEach(filteredRoutes) { route in
                        MapPolyline(coordinates: route.clCoordinates)
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
                                        withAnimation {
                                            selectedRoute = route
                                            zoomTo(route)
                                        }
                                    }
                                    .onLongPressGesture {
                                        selectedRoute = route
                                        showDetail = true
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Detroit Hikes")
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
                                center: CLLocationCoordinate2D(latitude: 42.3505, longitude: -83.0558),
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
        }
    }

    private func zoomTo(_ route: HikeRoute) {
        position = .region(MKCoordinateRegion(
            center: route.centerCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        ))
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

import SwiftUI
import MapKit

struct PhotographyView: View {
    let route: HikeRoute
    @State private var selectedPin: ShotPin?
    @State private var showPinDetail = false
    @State private var solarTimes: SolarCalculator.SolarTimes?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: Golden Hour Banner
                GoldenHourBannerView(solarTimes: solarTimes, route: route)
                    .padding(.horizontal)

                // MARK: Shot Map
                ShotMapView(route: route, selectedPin: $selectedPin)
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)

                // MARK: Shot List
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "camera.aperture")
                            .foregroundColor(.orange)
                        Text("Shot List (\(route.shotPins.count))")
                            .font(.headline)
                    }
                    .padding(.horizontal)

                    ForEach(route.shotPins) { pin in
                        ShotPinCard(pin: pin, isSelected: selectedPin?.id == pin.id) {
                            selectedPin = pin
                            showPinDetail = true
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer(minLength: 24)
            }
            .padding(.top)
        }
        .navigationTitle("Photography")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            solarTimes = SolarCalculator.solarTimes(
                for: route.centerCoordinate,
                on: Date(),
                timeZone: TimeZone(identifier: "America/Detroit") ?? .current
            )
        }
        .sheet(isPresented: $showPinDetail) {
            if let pin = selectedPin {
                ShotPinDetailView(pin: pin)
            }
        }
    }
}

// MARK: - Golden Hour Banner

struct GoldenHourBannerView: View {
    let solarTimes: SolarCalculator.SolarTimes?
    let route: HikeRoute

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "sun.horizon.fill")
                    .foregroundColor(.orange)
                    .font(.title3)
                Text("Today's Light Windows")
                    .font(.headline)
                Spacer()
                Text(Date(), style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()

            Divider()

            if let times = solarTimes {
                HStack(spacing: 0) {
                    LightWindowCell(
                        icon: "sunrise.fill",
                        label: "Golden AM",
                        time: times.timeString(times.morningGoldenStart),
                        color: .orange
                    )
                    Divider().frame(height: 50)
                    LightWindowCell(
                        icon: "moon.haze.fill",
                        label: "Blue Hour AM",
                        time: times.timeString(times.morningBlueStart),
                        color: .indigo
                    )
                    Divider().frame(height: 50)
                    LightWindowCell(
                        icon: "sunset.fill",
                        label: "Golden PM",
                        time: times.timeString(times.eveningGoldenStart),
                        color: .orange
                    )
                    Divider().frame(height: 50)
                    LightWindowCell(
                        icon: "moon.fill",
                        label: "Blue Hour PM",
                        time: times.timeString(times.eveningBlueStart),
                        color: .indigo
                    )
                }
                .padding(.vertical, 8)
            } else {
                Text("Solar data unavailable")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }
}

struct LightWindowCell: View {
    let icon: String
    let label: String
    let time: String
    let color: Color

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 18))
            Text(time)
                .font(.subheadline)
                .fontWeight(.semibold)
                .monospacedDigit()
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }
}

// MARK: - Shot Map

struct ShotMapView: View {
    let route: HikeRoute
    @Binding var selectedPin: ShotPin?

    var body: some View {
        Map {
            MapPolyline(coordinates: route.clCoordinates)
                .stroke(Color.blue.opacity(0.5), lineWidth: 2.5)

            ForEach(route.shotPins) { pin in
                Annotation(pin.title, coordinate: pin.clCoordinate) {
                    Button {
                        selectedPin = pin
                    } label: {
                        ZStack {
                            Circle()
                                .fill(selectedPin?.id == pin.id ? Color.orange : Color.white)
                                .frame(width: 36, height: 36)
                                .shadow(radius: 3)
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14))
                                .foregroundColor(selectedPin?.id == pin.id ? .white : .orange)
                        }
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
    }
}

// MARK: - Shot Pin Card

struct ShotPinCard: View {
    let pin: ShotPin
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: pin.bestTimeOfDay.icon)
                        .font(.system(size: 20))
                        .foregroundColor(.orange)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(pin.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text(pin.shootingNotes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    HStack(spacing: 8) {
                        Label(pin.bestTimeOfDay.rawValue, systemImage: pin.bestTimeOfDay.icon)
                        Label(pin.suggestedFocalLength, systemImage: "scope")
                    }
                    .font(.caption2)
                    .foregroundColor(.orange)
                }
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.orange.opacity(0.08) : Color(.secondarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Shot Pin Detail Sheet

struct ShotPinDetailView: View {
    let pin: ShotPin
    @Environment(\.dismiss) var dismiss

    // Kamra deep link — update scheme if different
    private let kamraScheme = "kamra://"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Mini map
                    Map {
                        Annotation(pin.title, coordinate: pin.clCoordinate) {
                            Image(systemName: "camera.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)

                    // Details
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Shooting Notes")
                                .font(.headline)
                            Text(pin.shootingNotes)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }

                        HStack(spacing: 16) {
                            DetailChip(icon: pin.bestTimeOfDay.icon,
                                       label: pin.bestTimeOfDay.rawValue,
                                       color: .orange)
                            DetailChip(icon: "scope",
                                       label: pin.suggestedFocalLength,
                                       color: .blue)
                        }

                        // Tags
                        if !pin.tags.isEmpty {
                            FlowLayout(tags: pin.tags.map { $0.rawValue })
                        }

                        Divider()

                        // Kamra integration
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Kamra Integration", systemImage: "camera.aperture")
                                .font(.headline)

                            Button {
                                openInKamra()
                            } label: {
                                Label("Open Location in Kamra", systemImage: "arrow.up.right.square")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.orange)
                                    .cornerRadius(10)
                            }

                            Text("Opens this GPS pin in Kamra with the shooting notes pre-loaded.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 32)
                }
            }
            .navigationTitle(pin.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func openInKamra() {
        // Deep link format: kamra://location?lat=42.33&lng=-83.04&note=...
        // Update this URL scheme to match Kamra's actual scheme
        let lat   = pin.coordinate.latitude
        let lng   = pin.coordinate.longitude
        let note  = pin.shootingNotes.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(kamraScheme)location?lat=\(lat)&lng=\(lng)&note=\(note)"

        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // Kamra not installed — fallback to Apple Maps with the pin
            let mapsURL = URL(string: "maps://q=\(lat),\(lng)")!
            UIApplication.shared.open(mapsURL)
        }
    }
}

// MARK: - Supporting Views

struct DetailChip: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        Label(label, systemImage: icon)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.12))
            .cornerRadius(8)
    }
}

struct FlowLayout: View {
    let tags: [String]

    var body: some View {
        // Simple horizontal wrap using LazyVGrid
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 80), spacing: 8)],
            alignment: .leading,
            spacing: 8
        ) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(8)
            }
        }
    }
}

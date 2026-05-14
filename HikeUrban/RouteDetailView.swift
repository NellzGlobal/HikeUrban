import SwiftUI
import MapKit

struct RouteDetailView: View {
    let route: HikeRoute
    @State private var selectedMode: RouteMode
    @State private var selectedSection = 0
    @Environment(\.dismiss) var dismiss

    init(route: HikeRoute) {
        self.route = route
        _selectedMode = State(initialValue: route.supportedModes.first ?? .walk)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: Mini Map
                    Map {
                        MapPolyline(coordinates: route.clCoordinates)
                            .stroke(Color.orange, lineWidth: 4)
                        if let first = route.clCoordinates.first {
                            Annotation("Start", coordinate: first) {
                                Image(systemName: "flag.fill").foregroundColor(.green)
                            }
                        }
                    }
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)

                    // MARK: Mode Selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mode")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(route.supportedModes) { mode in
                                    ModeButton(
                                        mode: mode,
                                        isSelected: selectedMode == mode,
                                        estimatedMinutes: route.estimatedMinutes(for: mode)
                                    ) {
                                        selectedMode = mode
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // MARK: Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        StatCell(label: "Distance",   value: String(format: "%.1f mi", route.distanceMiles), icon: "arrow.left.and.right")
                        StatCell(label: "Elevation",  value: "\(Int(route.elevationGainFt)) ft",             icon: "arrow.up.right")
                        StatCell(label: "Est. Time",  value: "\(route.estimatedMinutes(for: selectedMode)) min", icon: "clock")
                        StatCell(label: "Difficulty", value: route.difficulty.rawValue,                      icon: "figure.hiking")
                        StatCell(label: "Rating",     value: String(format: "★ %.1f", route.rating),         icon: "star.fill")
                        StatCell(label: "Reviews",    value: "\(route.reviewCount)",                         icon: "bubble.left")
                    }
                    .padding(.horizontal)

                    // MARK: Section Tabs
                    Picker("", selection: $selectedSection) {
                        Text("About").tag(0)
                        Text("Photography").tag(1)
                        Text("History").tag(2)
                        Text("Access").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // MARK: Section Content
                    Group {
                        switch selectedSection {
                        case 0: AboutSection(route: route)
                        case 1: PhotographySectionPreview(route: route)
                        case 2: HistorySection(route: route)
                        case 3: AccessibilitySection(route: route)
                        default: EmptyView()
                        }
                    }
                    .padding(.horizontal)

                    // MARK: Start Button
                    Button {
                        dismiss()
                    } label: {
                        Label("Start this Hike", systemImage: selectedMode.icon)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationTitle(route.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Mode Button

struct ModeButton: View {
    let mode: RouteMode
    let isSelected: Bool
    let estimatedMinutes: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: mode.icon)
                    .font(.title3)
                Text(mode.rawValue)
                    .font(.caption2)
                Text("\(estimatedMinutes)m")
                    .font(.caption2)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(width: 70)
            .padding(.vertical, 8)
            .background(isSelected ? Color.orange : Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - About Section

struct AboutSection: View {
    let route: HikeRoute

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About this Route")
                .font(.headline)
            Text(route.description)
                .font(.body)
                .foregroundColor(.secondary)

            DarkSafetyRow(rating: route.darkSafety)
                .padding(.top, 4)

            if !route.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(route.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(.tertiarySystemBackground))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
}

struct DarkSafetyRow: View {
    let rating: DarkSafetyRating

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: rating.recommendedAfterDark ? "moon.stars.fill" : "moon.zzz.fill")
                .foregroundColor(rating.recommendedAfterDark ? .indigo : .secondary)

            VStack(alignment: .leading, spacing: 2) {
                Text(rating.recommendedAfterDark ? "After Dark Recommended" : "Daytime Recommended")
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(rating.communityNotes)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: i <= rating.lightingQuality ? "lightbulb.fill" : "lightbulb")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

// MARK: - Photography Section Preview

struct PhotographySectionPreview: View {
    let route: HikeRoute

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if route.shotPins.isEmpty {
                Text("No shot pins yet for this route.")
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                ForEach(route.shotPins) { pin in
                    HStack(spacing: 10) {
                        Image(systemName: pin.bestTimeOfDay.icon)
                            .foregroundColor(.orange)
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(pin.title).font(.subheadline).fontWeight(.medium)
                            Text(pin.shootingNotes).font(.caption).foregroundColor(.secondary).lineLimit(2)
                        }
                    }
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }

                NavigationLink {
                    PhotographyView(route: route)
                } label: {
                    Label("Open Full Photography Guide", systemImage: "camera.aperture")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
    }
}

// MARK: - History Section

struct HistorySection: View {
    let route: HikeRoute

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if route.historicalPoints.isEmpty {
                Text("No historical points on this route yet.")
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                ForEach(route.historicalPoints) { point in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                                .foregroundColor(.brown)
                            Text(point.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Spacer()
                            Text(point.era)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color(.tertiarySystemBackground))
                                .cornerRadius(6)
                        }
                        Text(point.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
            }
        }
    }
}

// MARK: - Accessibility Section

struct AccessibilitySection: View {
    let route: HikeRoute

    var a: AccessibilityInfo { route.accessibility }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            if a.accessibilityBadges.isEmpty {
                Text("This route has limited accessibility.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                HStack {
                    ForEach(a.accessibilityBadges, id: \.self) { badge in
                        Text(badge)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }

            VStack(spacing: 0) {
                AccessRow(label: "Surface",        value: a.surfaceType.rawValue)
                Divider()
                AccessRow(label: "Max Grade",      value: String(format: "%.1f%%", a.maxGradePercent))
                Divider()
                AccessRow(label: "Stair Sections", value: a.hasStairSections == 0 ? "None" : "\(a.hasStairSections) section(s)")
                Divider()
                AccessRow(label: "Wheelchair",     value: a.isWheelchairFriendly ? "✅ Yes" : "❌ No")
                Divider()
                AccessRow(label: "Stroller",       value: a.isStrollerFriendly ? "✅ Yes" : "❌ No")
                Divider()
                AccessRow(label: "Low Impact",     value: a.isLowImpact ? "✅ Yes" : "❌ No")
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)

            if !a.notes.isEmpty {
                Text(a.notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
    }
}

struct AccessRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

// MARK: - Stat Cell

struct StatCell: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.orange)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

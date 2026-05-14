import SwiftUI
import MapKit

// MARK: - Discover View
// Editor's Pick is live. Surprise Me is earmarked — needs user preference data.

struct DiscoverView: View {
    let routes = HikeRoute.featuredRoutes
    @State private var showSurpriseMe = false
    @State private var surpriseRoute: HikeRoute?

    var editorsPicks: [HikeRoute] { routes.filter { $0.isEditorsPick } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // MARK: Surprise Me
                    SurpriseMeBanner {
                        // TODO: personalise when user preference data exists
                        // For now: random from curated pool
                        surpriseRoute = routes.randomElement()
                        showSurpriseMe = true
                    }
                    .padding(.horizontal)

                    // MARK: Editor's Picks
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(
                            icon: "star.circle.fill",
                            title: "Editor's Picks",
                            subtitle: "Curated routes to get you exploring"
                        )
                        .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(editorsPicks) { route in
                                    NavigationLink {
                                        RouteDetailView(route: route)
                                    } label: {
                                        EditorPickCard(route: route)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // MARK: Dark-Friendly Routes
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(
                            icon: "moon.stars.fill",
                            title: "After Dark",
                            subtitle: "Community-rated safe for night hiking"
                        )
                        .padding(.horizontal)

                        ForEach(routes.filter { $0.darkSafety.recommendedAfterDark }) { route in
                            NavigationLink {
                                RouteDetailView(route: route)
                            } label: {
                                DarkRouteRow(route: route)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // MARK: Fully Accessible
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(
                            icon: "figure.roll",
                            title: "Accessible Routes",
                            subtitle: "Wheelchair & stroller friendly"
                        )
                        .padding(.horizontal)

                        ForEach(routes.filter { $0.accessibility.isWheelchairFriendly }) { route in
                            NavigationLink {
                                RouteDetailView(route: route)
                            } label: {
                                AccessibleRouteRow(route: route)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // MARK: Challenges — Earmarked
                    ChallengesTeaser()
                        .padding(.horizontal)

                    Spacer(minLength: 24)
                }
                .padding(.top)
            }
            .navigationTitle("Discover")
            .sheet(isPresented: $showSurpriseMe) {
                if let route = surpriseRoute {
                    SurpriseMeRevealSheet(route: route)
                }
            }
        }
    }
}

// MARK: - Surprise Me Banner

struct SurpriseMeBanner: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 56, height: 56)
                    Image(systemName: "wand.and.stars")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Surprise Me")
                        .font(.headline)
                    Text("Pick a random route and just go")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    // Earmark notice
                    Label("Gets smarter as you hike more", systemImage: "chart.line.uptrend.xyaxis")
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(14)
        }
        .buttonStyle(.plain)
    }
}

struct SurpriseMeRevealSheet: View {
    let route: HikeRoute
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "figure.hiking")
                    .font(.system(size: 64))
                    .foregroundColor(.orange)
                    .padding(.top, 32)

                Text("Today's Route")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text(route.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(route.neighborhood)
                    .font(.title3)
                    .foregroundColor(.secondary)

                HStack(spacing: 20) {
                    VStack {
                        Text(String(format: "%.1f", route.distanceMiles))
                            .font(.title2).fontWeight(.bold)
                        Text("miles").font(.caption).foregroundColor(.secondary)
                    }
                    VStack {
                        Text("\(Int(route.elevationGainFt))")
                            .font(.title2).fontWeight(.bold)
                        Text("ft gain").font(.caption).foregroundColor(.secondary)
                    }
                    VStack {
                        Text("\(route.estimatedMinutes)")
                            .font(.title2).fontWeight(.bold)
                        Text("min").font(.caption).foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(14)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("Let's Go")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(14)
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Editor's Pick Card (horizontal scroll)

struct EditorPickCard: View {
    let route: HikeRoute

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                // Map preview
                Map {
                    MapPolyline(coordinates: route.clCoordinates)
                        .stroke(Color.orange, lineWidth: 3)
                }
                .frame(width: 220, height: 130)
                .disabled(true)

                Label("Editor's Pick", systemImage: "star.fill")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange)
                    .cornerRadius(6)
                    .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(route.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)

            HStack {
                Text(route.neighborhood)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%.1f mi", route.distanceMiles))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 220)
    }
}

// MARK: - Dark Route Row

struct DarkRouteRow: View {
    let route: HikeRoute

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "moon.stars.fill")
                .font(.title3)
                .foregroundColor(.indigo)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 3) {
                Text(route.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(route.darkSafety.communityNotes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Lighting stars
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: i <= route.darkSafety.lightingQuality ? "moon.fill" : "moon")
                        .font(.caption2)
                        .foregroundColor(.indigo)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Accessible Route Row

struct AccessibleRouteRow: View {
    let route: HikeRoute

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "figure.roll")
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 3) {
                Text(route.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                HStack {
                    ForEach(route.accessibility.accessibilityBadges, id: \.self) { badge in
                        Text(badge)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Challenges Teaser (Earmarked)

struct ChallengesTeaser: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                icon: "trophy.fill",
                title: "Challenges",
                subtitle: "Coming soon"
            )

            HStack(spacing: 12) {
                ForEach(["Monthly Neighborhood\nChallenge", "Complete All\nEditor's Picks", "100 Floors\nClimbed"], id: \.self) { title in
                    VStack(spacing: 8) {
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text(title)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
            }

            Text("Challenges launch once you've completed your first 3 routes.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.orange)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

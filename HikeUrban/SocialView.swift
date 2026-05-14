import SwiftUI
import GameKit

// MARK: - Social View
// Leaderboards are structural/ready. Group hikes earmarked — needs backend + auth.

struct SocialView: View {
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selectedTab) {
                    Text("Leaderboard").tag(0)
                    Text("Group Hikes").tag(1)
                    Text("Feed").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()

                TabView(selection: $selectedTab) {
                    LeaderboardView()      .tag(0)
                    GroupHikesView()       .tag(1)
                    ActivityFeedView()     .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Community")
        }
    }
}

// MARK: - Leaderboard

struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let neighborhood: String
    let milesThisMonth: Double
    let floorsClimbed: Int
    let steps: Int
    let isCurrentUser: Bool
}

struct LeaderboardView: View {
    @EnvironmentObject var hikeStore: HikeStore
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var gcManager: GameCenterManager

    @State private var selectedMetric = 0

    private let communityEntries: [LeaderboardEntry] = [
        LeaderboardEntry(rank: 0, name: "Maria K.",   neighborhood: "", milesThisMonth: 48.2, floorsClimbed: 312, steps: 98_400, isCurrentUser: false),
        LeaderboardEntry(rank: 0, name: "James T.",   neighborhood: "", milesThisMonth: 41.7, floorsClimbed: 287, steps: 84_200, isCurrentUser: false),
        LeaderboardEntry(rank: 0, name: "Aaliyah R.", neighborhood: "", milesThisMonth: 38.1, floorsClimbed: 201, steps: 76_800, isCurrentUser: false),
        LeaderboardEntry(rank: 0, name: "Devon S.",   neighborhood: "", milesThisMonth: 18.9, floorsClimbed: 143, steps: 38_100, isCurrentUser: false),
    ]

    // Real GC entries mapped to our display type
    private var gcLeaderboardEntries: [LeaderboardEntry] {
        gcManager.entries.map { e in
            LeaderboardEntry(rank: e.rank, name: e.displayName, neighborhood: "",
                             milesThisMonth: 0, floorsClimbed: 0,
                             steps: e.steps, isCurrentUser: e.isLocalPlayer)
        }
    }

    private var localEntries: [LeaderboardEntry] {
        let userName = profile.displayName.isEmpty ? "You" : profile.displayName
        let hood     = profile.homeNeighborhood.isEmpty ? "Detroit" : profile.homeNeighborhood
        let me = LeaderboardEntry(rank: 0, name: userName, neighborhood: hood,
                                  milesThisMonth: hikeStore.totalMiles,
                                  floorsClimbed: hikeStore.totalFloorsClimbed,
                                  steps: hikeStore.totalSteps, isCurrentUser: true)
        let sorted = (communityEntries + [me]).sorted {
            switch selectedMetric {
            case 1:  return $0.floorsClimbed > $1.floorsClimbed
            case 2:  return $0.steps > $1.steps
            default: return $0.milesThisMonth > $1.milesThisMonth
            }
        }
        return sorted.enumerated().map { i, e in
            LeaderboardEntry(rank: i + 1, name: e.name, neighborhood: e.neighborhood,
                             milesThisMonth: e.milesThisMonth, floorsClimbed: e.floorsClimbed,
                             steps: e.steps, isCurrentUser: e.isCurrentUser)
        }
    }

    private var useGameCenter: Bool {
        selectedMetric == 2 && gcManager.isAuthenticated && !gcManager.entries.isEmpty
    }

    private var displayEntries: [LeaderboardEntry] {
        useGameCenter ? gcLeaderboardEntries : localEntries
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Picker("Metric", selection: $selectedMetric) {
                    Text("Miles").tag(0)
                    Text("Floors").tag(1)
                    Text("Steps").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: selectedMetric) { _, new in
                    if new == 2 && gcManager.isAuthenticated && gcManager.entries.isEmpty {
                        gcManager.loadLeaderboard()
                    }
                }

                // Game Center status banner (Steps tab only)
                if selectedMetric == 2 {
                    if gcManager.isAuthenticated {
                        HStack {
                            Image(systemName: "gamecontroller.fill")
                                .foregroundColor(.green)
                            Text("Connected to Game Center")
                                .font(.caption).fontWeight(.medium)
                            Spacer()
                            Button("Full Board") { gcManager.presentFullLeaderboard() }
                                .font(.caption).fontWeight(.semibold)
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                    } else {
                        Button {
                            gcManager.authenticate()
                        } label: {
                            HStack {
                                Image(systemName: "gamecontroller")
                                Text("Connect Game Center for live leaderboard")
                                    .font(.caption).fontWeight(.medium)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption2)
                            }
                            .foregroundColor(.orange)
                            .padding()
                            .background(Color.orange.opacity(0.08))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                    }
                }

                if gcManager.isLoading {
                    ProgressView("Loading scores…")
                        .padding()
                } else {
                    PodiumView(entries: Array(displayEntries.prefix(3)), metric: selectedMetric)
                        .padding(.bottom)

                    VStack(spacing: 0) {
                        ForEach(displayEntries) { entry in
                            LeaderboardRow(entry: entry, metric: selectedMetric)
                            if entry.id != displayEntries.last?.id {
                                Divider().padding(.leading, 60)
                            }
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(14)
                    .padding(.horizontal)

                    if !useGameCenter {
                        Text("Miles & Floors show demo data. Steps uses live Game Center scores.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                    }
                }
            }
        }
    }
}

struct PodiumView: View {
    let entries: [LeaderboardEntry]
    let metric: Int

    private func label(for entry: LeaderboardEntry) -> String {
        switch metric {
        case 1:  return "\(entry.floorsClimbed) fl"
        case 2:  return entry.steps >= 1000 ? String(format: "%.1fk steps", Double(entry.steps) / 1000) : "\(entry.steps) steps"
        default: return String(format: "%.1f mi", entry.milesThisMonth)
        }
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if entries.count > 1 {
                PodiumSlot(entry: entries[1], height: 80, medal: "🥈", label: label(for: entries[1]))
            }
            if entries.count > 0 {
                PodiumSlot(entry: entries[0], height: 110, medal: "🥇", label: label(for: entries[0]))
            }
            if entries.count > 2 {
                PodiumSlot(entry: entries[2], height: 60, medal: "🥉", label: label(for: entries[2]))
            }
        }
        .padding(.horizontal, 32)
        .padding(.top)
    }
}

struct PodiumSlot: View {
    let entry: LeaderboardEntry
    let height: CGFloat
    let medal: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(medal).font(.title)
            Text(entry.name)
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)

            RoundedRectangle(cornerRadius: 8)
                .fill(entry.isCurrentUser ? Color.orange.opacity(0.35) : Color.orange.opacity(0.2))
                .frame(height: height)
        }
        .frame(maxWidth: .infinity)
    }
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    let metric: Int

    var value: String {
        switch metric {
        case 1:  return "\(entry.floorsClimbed) floors"
        case 2:  return entry.steps >= 1000
                     ? String(format: "%.1fk steps", Double(entry.steps) / 1000)
                     : "\(entry.steps) steps"
        default: return String(format: "%.1f mi", entry.milesThisMonth)
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Text("#\(entry.rank)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(entry.rank <= 3 ? .orange : .secondary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(.subheadline)
                    .fontWeight(entry.isCurrentUser ? .bold : .regular)
                Text(entry.neighborhood)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(entry.isCurrentUser ? .orange : .primary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(entry.isCurrentUser ? Color.orange.opacity(0.06) : Color.clear)
    }
}

// MARK: - Group Hikes (Earmarked — needs auth + backend)

struct GroupHikesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Earmark notice
                HStack {
                    Image(systemName: "hammer.fill")
                        .foregroundColor(.orange)
                    Text("Group Hikes — In Development")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

                // Preview cards (static)
                ForEach(GroupHike.samples) { hike in
                    GroupHikeCard(hike: hike)
                        .padding(.horizontal)
                }

                Text("Scheduling and RSVP requires account sign-in — coming in the next update.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.top)
        }
    }
}

struct GroupHike: Identifiable {
    let id = UUID()
    let title: String
    let route: String
    let date: String
    let attendees: Int
    let maxSize: Int
    let organizer: String

    static let samples = [
        GroupHike(title: "Saturday Morning Riverwalk", route: "Detroit Riverfront Walk",
                  date: "Sat, May 17 · 8:00 AM", attendees: 7, maxSize: 15, organizer: "Maria K."),
        GroupHike(title: "Dequindre Cut Sunset Run", route: "Dequindre Cut Greenway",
                  date: "Sun, May 18 · 6:30 PM", attendees: 4, maxSize: 10, organizer: "James T."),
        GroupHike(title: "Corktown History Walk", route: "Corktown Heritage Trail",
                  date: "Sat, May 24 · 10:00 AM", attendees: 11, maxSize: 12, organizer: "Aaliyah R."),
    ]
}

struct GroupHikeCard: View {
    let hike: GroupHike

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(hike.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(hike.attendees)/\(hike.maxSize)")
                    .font(.caption)
                    .foregroundColor(hike.attendees >= hike.maxSize ? .red : .secondary)
            }

            Label(hike.date, systemImage: "calendar")
                .font(.caption)
                .foregroundColor(.secondary)

            Label(hike.route, systemImage: "map")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                Label("By \(hike.organizer)", systemImage: "person.circle")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Button("RSVP") { /* earmarked */ }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(hike.attendees >= hike.maxSize ? Color.gray : Color.orange)
                    .cornerRadius(8)
                    .disabled(hike.attendees >= hike.maxSize)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Activity Feed (stub)

struct ActivityFeedView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(FeedItem.samples) { item in
                    FeedCard(item: item)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
}

struct FeedItem: Identifiable {
    let id = UUID()
    let userName: String
    let action: String
    let routeName: String
    let stats: String
    let timeAgo: String

    static let samples = [
        FeedItem(userName: "Maria K.", action: "completed", routeName: "Detroit Riverfront Walk",
                 stats: "2.8 mi · 18 ft · 52 min", timeAgo: "2h ago"),
        FeedItem(userName: "James T.", action: "completed", routeName: "Dequindre Cut Greenway",
                 stats: "1.4 mi · 22 ft · 28 min", timeAgo: "4h ago"),
        FeedItem(userName: "Aaliyah R.", action: "completed", routeName: "Midtown Art & Culture Loop",
                 stats: "3.1 mi · 42 ft · 61 min", timeAgo: "Yesterday"),
    ]
}

struct FeedCard: View {
    let item: FeedItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "figure.hiking.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.orange, .orange.opacity(0.2))

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.userName).fontWeight(.semibold)
                    Text(item.action).foregroundColor(.secondary)
                    Spacer()
                    Text(item.timeAgo).font(.caption).foregroundColor(.secondary)
                }
                .font(.subheadline)

                Text(item.routeName)
                    .font(.subheadline)
                    .foregroundColor(.orange)

                Text(item.stats)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var hikeStore: HikeStore
    @EnvironmentObject var profile: UserProfile
    @State private var showEditProfile = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: Avatar + Name
                    VStack(spacing: 10) {
                        AvatarView(profile: profile, size: 90)
                            .onTapGesture { showEditProfile = true }

                        if profile.displayName.isEmpty {
                            Button("Set up your profile") {
                                showEditProfile = true
                            }
                            .font(.headline)
                            .foregroundColor(.orange)
                        } else {
                            Text(profile.displayName)
                                .font(.title2).fontWeight(.bold)

                            if !profile.homeNeighborhood.isEmpty {
                                Label(profile.homeNeighborhood, systemImage: "mappin.circle")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            if !profile.bio.isEmpty {
                                Text(profile.bio)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }
                        }
                    }
                    .padding(.top)

                    // MARK: Real Stats
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ProfileStatCard(
                            value: "\(hikeStore.totalHikes)",
                            label: "Hikes",
                            icon: "figure.hiking"
                        )
                        ProfileStatCard(
                            value: hikeStore.totalHikes == 0 ? "0.0" : String(format: "%.1f", hikeStore.totalMiles),
                            label: "Miles",
                            icon: "map"
                        )
                        ProfileStatCard(
                            value: hikeStore.totalHikes == 0 ? "0 ft" : "\(Int(hikeStore.totalElevationFt)) ft",
                            label: "Total Gain",
                            icon: "arrow.up.right"
                        )
                        ProfileStatCard(
                            value: hikeStore.currentStreak == 0 ? "0" : "\(hikeStore.currentStreak) 🔥",
                            label: "Day Streak",
                            icon: "flame"
                        )
                    }
                    .padding(.horizontal)

                    // MARK: Floors Climbed
                    if hikeStore.totalFloorsClimbed > 0 {
                        HStack {
                            Image(systemName: "stairs")
                                .font(.title3)
                                .foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(hikeStore.totalFloorsClimbed) floors climbed")
                                    .font(.subheadline).fontWeight(.semibold)
                                Text("≈ \(hikeStore.totalFloorsClimbed * 11) stair steps total")
                                    .font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }

                    // MARK: Recent Hikes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Hikes")
                            .font(.headline)
                            .padding(.horizontal)

                        if hikeStore.completedHikes.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "figure.hiking.circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                Text("No hikes yet")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Head to the Record tab to log your first urban hike.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(32)
                        } else {
                            ForEach(hikeStore.recentHikes) { hike in
                                HikePathCard(hike: hike)
                                    .padding(.horizontal)
                            }
                        }
                    }

                    Spacer(minLength: 32)
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showEditProfile = true
                    } label: {
                        Image(systemName: "pencil.circle")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileSheet()
                    .environmentObject(profile)
            }
        }
    }
}

// MARK: - Avatar View

struct AvatarView: View {
    @ObservedObject var profile: UserProfile
    let size: CGFloat

    var body: some View {
        Group {
            if let img = profile.profileImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.orange, lineWidth: 2))
            } else {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: size, height: size)
                        .overlay(Circle().stroke(Color.orange, lineWidth: 2))

                    if profile.initials.isEmpty {
                        Image(systemName: "figure.hiking")
                            .font(.system(size: size * 0.4))
                            .foregroundColor(.orange)
                    } else {
                        Text(profile.initials)
                            .font(.system(size: size * 0.35, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .shadow(radius: 3)
    }
}

// MARK: - Hike Path Card

struct HikePathCard: View {
    let hike: CompletedHike
    @EnvironmentObject var hikeStore: HikeStore
    @State private var gpxURL: URL?
    @State private var showNotesEditor = false

    var body: some View {
        VStack(spacing: 0) {

            // Map snapshot header
            Group {
                if let img = hike.mapImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                } else if !hike.routeCoordinates.isEmpty {
                    // Snapshot still generating
                    ZStack {
                        Color(.secondarySystemBackground)
                        ProgressView()
                    }
                } else {
                    // No GPS data recorded
                    ZStack {
                        Color(.secondarySystemBackground)
                        Image(systemName: hike.mode.icon)
                            .font(.system(size: 36))
                            .foregroundColor(.orange.opacity(0.4))
                    }
                }
            }
            .frame(height: 160)
            .clipped()
            .overlay(alignment: .topLeading) {
                Label(hike.mode.rawValue, systemImage: hike.mode.icon)
                    .font(.caption2).fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(8)
            }

            // Stats footer
            VStack(spacing: 6) {
                HStack {
                    Text(hike.name)
                        .font(.subheadline).fontWeight(.semibold)
                        .lineLimit(1)
                    Spacer()
                    Text(hike.dateFormatted)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 0) {
                    MiniStat(value: String(format: "%.2f", hike.distanceMiles), unit: "mi")
                    Divider().frame(height: 28).padding(.horizontal, 8)
                    MiniStat(value: "\(Int(hike.elevationGainFt))", unit: "ft gain")
                    Divider().frame(height: 28).padding(.horizontal, 8)
                    MiniStat(value: hike.durationFormatted, unit: "time")
                    if hike.floorsAscended > 0 {
                        Divider().frame(height: 28).padding(.horizontal, 8)
                        MiniStat(value: "\(hike.floorsAscended)", unit: "floors")
                    }
                    Spacer()

                    if let url = gpxURL {
                        ShareLink(
                            item: url,
                            preview: SharePreview("\(hike.name).gpx", icon: Image(systemName: "map"))
                        ) {
                            Label("GPX", systemImage: "square.and.arrow.up")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                    }
                }

                // Notes row
                HStack(alignment: .top, spacing: 6) {
                    if hike.notes.isEmpty {
                        Text("Add notes…")
                            .font(.caption)
                            .foregroundColor(.secondary.opacity(0.6))
                    } else {
                        Text(hike.notes)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    Spacer()
                    Button {
                        showNotesEditor = true
                    } label: {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        .onAppear { gpxURL = hike.gpxFileURL() }
        .sheet(isPresented: $showNotesEditor) {
            NotesEditorSheet(hike: hike) { saved in
                hikeStore.updateNotes(saved, for: hike.id)
                gpxURL = hike.gpxFileURL()
            }
        }
    }
}

private struct MiniStat: View {
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 1) {
            Text(value).font(.subheadline).fontWeight(.bold).monospacedDigit()
            Text(unit).font(.caption2).foregroundColor(.secondary)
        }
    }
}

// MARK: - Edit Profile Sheet

struct EditProfileSheet: View {
    @EnvironmentObject var profile: UserProfile
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var neighborhood: String = ""
    @State private var bio: String = ""
    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        ZStack(alignment: .bottomTrailing) {
                            AvatarView(profile: profile, size: 90)

                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                Image(systemName: "camera.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.white, .orange)
                                    .background(Color.white.clipShape(Circle()))
                            }
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                Section("Your Info") {
                    TextField("Display Name", text: $name)
                    TextField("Bio (optional)", text: $bio, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Home Neighbourhood") {
                    TextField("e.g. Midtown, Brooklyn, Shoreditch…", text: $neighborhood)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        profile.displayName      = name
                        profile.homeNeighborhood = neighborhood
                        profile.bio              = bio
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                name         = profile.displayName
                neighborhood = profile.homeNeighborhood
                bio          = profile.bio
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        await MainActor.run { profile.profileImageData = data }
                    }
                }
            }
        }
    }
}

// MARK: - Notes Editor Sheet

struct NotesEditorSheet: View {
    let hike: CompletedHike
    let onSave: (String) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var text: String

    init(hike: CompletedHike, onSave: @escaping (String) -> Void) {
        self.hike = hike
        self.onSave = onSave
        _text = State(initialValue: hike.notes)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(hike.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                TextEditor(text: $text)
                    .font(.body)
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .frame(minHeight: 140)

                Text("Notes are saved with the hike and included in GPX exports.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Hike Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(text)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Profile Stat Card

struct ProfileStatCard: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.orange)
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3).fontWeight(.bold)
                Text(label)
                    .font(.caption).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

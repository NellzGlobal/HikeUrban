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
                                Text("Head to the Record tab to log your first Detroit hike.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(32)
                        } else {
                            ForEach(hikeStore.recentHikes) { hike in
                                CompletedHikeRow(hike: hike)
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

// MARK: - Completed Hike Row

struct CompletedHikeRow: View {
    let hike: CompletedHike

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: hike.mode.icon)
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 3) {
                Text(hike.name)
                    .font(.subheadline).fontWeight(.medium)
                    .lineLimit(1)
                HStack(spacing: 10) {
                    Text(String(format: "%.2f mi", hike.distanceMiles))
                    Text("·")
                    Text("\(Int(hike.elevationGainFt)) ft")
                    Text("·")
                    Text(hike.durationFormatted)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            Text(hike.dateFormatted)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
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

    let detroitNeighborhoods = [
        "Downtown", "Midtown", "Corktown", "Eastern Market",
        "New Center", "Rivertown", "Greektown", "Mexicantown",
        "North End", "Woodbridge", "Other"
    ]

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
                    Picker("Neighbourhood", selection: $neighborhood) {
                        Text("None").tag("")
                        ForEach(detroitNeighborhoods, id: \.self) { n in
                            Text(n).tag(n)
                        }
                    }
                    .pickerStyle(.menu)
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

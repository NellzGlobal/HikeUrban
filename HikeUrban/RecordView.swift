import SwiftUI
import MapKit

struct RecordView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var hikeStore: HikeStore
    @EnvironmentObject var gcManager: GameCenterManager
    @StateObject private var staircaseManager = StaircaseManager()

    @State private var selectedMode: RouteMode = .walk
    @State private var showSaveSheet = false
    @State private var hikeName = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LiveMapView()
                    .ignoresSafeArea(edges: .top)

                VStack {
                    if !locationManager.isRecording && locationManager.currentSession == nil {
                        ModePickerBar(selectedMode: $selectedMode)
                            .padding(.top, 8)
                            .padding(.horizontal)
                    }

                    Spacer()

                    if locationManager.isRecording || locationManager.currentSession != nil {
                        SessionStatsBar(
                            session: locationManager.currentSession,
                            elapsed: locationManager.elapsedSeconds,
                            floorsAscended: staircaseManager.floorsAscended
                        )
                        .padding(.horizontal)
                    }

                    if locationManager.isRecording {
                        HStack(spacing: 20) {
                            Button {
                                staircaseManager.stopCounting()
                                locationManager.discardSession()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                    .padding(16)
                                    .background(Color(.systemBackground))
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }

                            Button {
                                locationManager.stopRecording()
                                staircaseManager.stopCounting()
                                hikeName = defaultHikeName
                                showSaveSheet = true
                            } label: {
                                Image(systemName: "stop.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .padding(24)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .shadow(radius: 6)
                            }
                        }
                        .padding(.bottom, 32)

                    } else {
                        Button {
                            locationManager.startRecording()
                            locationManager.currentSession?.mode = selectedMode
                            staircaseManager.startCounting(from: Date())
                        } label: {
                            HStack {
                                Image(systemName: selectedMode.icon)
                                Text("Start \(selectedMode.rawValue)")
                                    .fontWeight(.semibold)
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 36)
                            .background(Color.orange)
                            .clipShape(Capsule())
                            .shadow(radius: 6)
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Record")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                locationManager.requestPermission()
            }
        }
        .sheet(isPresented: $showSaveSheet) {
            SaveHikeSheet(
                session: locationManager.currentSession,
                hikeName: $hikeName,
                floorsAscended: staircaseManager.floorsAscended,
                steps: staircaseManager.stepCount
            ) { shouldSave in
                if shouldSave, let session = locationManager.currentSession {
                    var named = session
                    named.name = hikeName
                    hikeStore.add(
                        from: named,
                        floorsAscended: staircaseManager.floorsAscended,
                        steps: staircaseManager.stepCount
                    )
                    gcManager.submitScore(hikeStore.totalSteps)
                }
                locationManager.currentSession = nil
                locationManager.elapsedSeconds = 0
            }
        }
    }

    private var defaultHikeName: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return "Urban \(selectedMode.rawValue) · \(f.string(from: Date()))"
    }
}

// MARK: - Mode Picker Bar

struct ModePickerBar: View {
    @Binding var selectedMode: RouteMode

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(RouteMode.allCases) { mode in
                    Button {
                        selectedMode = mode
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: mode.icon)
                            Text(mode.rawValue)
                        }
                        .font(.subheadline)
                        .fontWeight(selectedMode == mode ? .semibold : .regular)
                        .foregroundColor(selectedMode == mode ? .white : .primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedMode == mode ? Color.orange : Color(.systemBackground).opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: selectedMode == mode ? 2 : 0)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Live Map

struct LiveMapView: View {
    @EnvironmentObject var locationManager: LocationManager

    @State private var position: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)

    var body: some View {
        Map(position: $position) {
            UserAnnotation()
            // Raw GPS path — shows immediately, faint, covers the unsnapped leading segment
            if let session = locationManager.currentSession, session.locations.count > 1 {
                MapPolyline(coordinates: session.locations.map(\.coordinate))
                    .stroke(Color.orange.opacity(0.3), lineWidth: 3)
            }
            // Road-snapped path — solid orange, trails ~75m behind current position
            if locationManager.snappedPath.count > 1 {
                MapPolyline(coordinates: locationManager.snappedPath)
                    .stroke(Color.orange, lineWidth: 4)
            }
        }
        .onChange(of: locationManager.location) { _, newLoc in
            if let loc = newLoc {
                withAnimation(.easeInOut(duration: 0.5)) {
                    position = .region(MKCoordinateRegion(
                        center: loc.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }
            }
        }
    }
}

// MARK: - Stats Bar

struct SessionStatsBar: View {
    let session: HikeSession?
    let elapsed: Int
    let floorsAscended: Int

    private var durationString: String {
        let h = elapsed / 3600, m = (elapsed % 3600) / 60, s = elapsed % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, s)
                     : String(format: "%d:%02d", m, s)
    }

    var body: some View {
        HStack(spacing: 0) {
            StatPill(value: durationString,
                     label: "Time", icon: "clock.fill")
            Divider().frame(height: 40)
            StatPill(value: String(format: "%.2f", session?.distanceMiles ?? 0),
                     label: "Miles", icon: "arrow.left.and.right")
            Divider().frame(height: 40)
            StatPill(value: "\(Int(session?.elevationGainFt ?? 0)) ft",
                     label: "Gain", icon: "arrow.up.right")
            Divider().frame(height: 40)
            StatPill(value: "\(floorsAscended)",
                     label: "Floors", icon: "stairs")
        }
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

struct StatPill: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon).font(.caption2).foregroundColor(.orange)
            Text(value).font(.subheadline).fontWeight(.bold).monospacedDigit()
            Text(label).font(.caption2).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}

// MARK: - Save Hike Sheet

struct SaveHikeSheet: View {
    let session: HikeSession?
    @Binding var hikeName: String
    let floorsAscended: Int
    let steps: Int
    let onDismiss: (Bool) -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Name your hike") {
                    TextField("e.g. Morning Midtown Loop", text: $hikeName)
                }
                if let s = session {
                    Section("Your Stats") {
                        LabeledContent("Distance",       value: String(format: "%.2f miles", s.distanceMiles))
                        LabeledContent("Elevation Gain", value: String(format: "%.0f ft", s.elevationGainFt))
                        LabeledContent("Duration",       value: s.durationFormatted)
                        LabeledContent("Steps",          value: steps > 0 ? "\(steps.formatted())" : "—")
                        LabeledContent("Floors Climbed", value: "\(floorsAscended)")
                    }
                }
            }
            .navigationTitle("Save Hike")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Discard") {
                        onDismiss(false)
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onDismiss(true)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(hikeName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

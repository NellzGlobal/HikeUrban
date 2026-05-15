import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var hikeStore: HikeStore
    @EnvironmentObject var profile: UserProfile

    @State private var selectedTab = 0
    @State private var showProfileSetup = false

    var body: some View {
        TabView(selection: $selectedTab) {

            ExploreView()
                .tabItem { Label("Explore",   systemImage: "map") }
                .tag(0)

            DiscoverView()
                .tabItem { Label("Discover",  systemImage: "star.circle") }
                .tag(1)

            RecordView()
                .tabItem { Label("Record",    systemImage: "record.circle") }
                .tag(2)

            RouteBuilderView()
                .tabItem { Label("Build",     systemImage: "pencil.and.ruler") }
                .tag(3)

            SocialView()
                .tabItem { Label("Community", systemImage: "person.2") }
                .tag(4)

            ProfileView()
                .tabItem { Label("Profile",   systemImage: "person.circle") }
                .tag(5)
        }
        .accentColor(.orange)
        .onChange(of: hikeStore.followRoute?.id) { _, id in
            if id != nil { selectedTab = 2 }
        }
        .onAppear {
            locationManager.requestPermission()
            if !profile.isSetUp {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    showProfileSetup = true
                }
            }
        }
        .sheet(isPresented: $showProfileSetup) {
            EditProfileSheet()
                .environmentObject(profile)
        }
    }
}

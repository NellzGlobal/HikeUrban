import SwiftUI

@main
struct HikeUrbanApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var hikeStore       = HikeStore()
    @StateObject private var userProfile     = UserProfile()
    @StateObject private var gcManager       = GameCenterManager()
    @StateObject private var cityStore       = CityStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(hikeStore)
                .environmentObject(userProfile)
                .environmentObject(gcManager)
                .environmentObject(cityStore)
                .onAppear { gcManager.authenticate() }
                .onChange(of: locationManager.location) { _, loc in
                    if let loc { cityStore.autoSelect(near: loc) }
                }
        }
    }
}

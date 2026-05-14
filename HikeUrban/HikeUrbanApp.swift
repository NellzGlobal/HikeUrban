import SwiftUI

@main
struct HikeUrbanApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var hikeStore       = HikeStore()
    @StateObject private var userProfile     = UserProfile()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(hikeStore)
                .environmentObject(userProfile)
        }
    }
}

import Foundation
import CoreLocation
import Combine

class CityStore: ObservableObject {
    @Published var selectedCity: FeaturedCity

    // Only auto-switch once per launch so the user doesn't get bumped mid-session
    private var hasAutoSelected = false

    init() {
        selectedCity = FeaturedCity.all[0]
    }

    func autoSelect(near location: CLLocation) {
        guard !hasAutoSelected else { return }
        guard let nearest = FeaturedCity.all.min(by: { a, b in
            let la = CLLocation(latitude: a.center.latitude, longitude: a.center.longitude)
            let lb = CLLocation(latitude: b.center.latitude, longitude: b.center.longitude)
            return location.distance(from: la) < location.distance(from: lb)
        }) else { return }
        hasAutoSelected = true
        selectedCity = nearest
    }
}

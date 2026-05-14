import Foundation
import CoreLocation

class CityStore: ObservableObject {
    @Published var selectedCity: FeaturedCity
    @Published var userCities: [FeaturedCity] = []

    private var hasAutoSelected = false
    private let storageKey = "userCities_v1"

    var allCities: [FeaturedCity] { FeaturedCity.all + userCities }

    init() {
        selectedCity = FeaturedCity.all[0]
        loadUserCities()
    }

    // MARK: - City Management

    func createCity(name: String, emoji: String, center: CLLocationCoordinate2D) {
        let city = FeaturedCity(
            id: UUID().uuidString,
            name: name.trimmingCharacters(in: .whitespaces),
            state: "",
            emoji: emoji.trimmingCharacters(in: .whitespaces).isEmpty ? "📍" : emoji,
            tagline: "My saved routes",
            center: center,
            routes: [],
            neighborhoods: [],
            isUserCreated: true
        )
        userCities.append(city)
        selectedCity = city
        saveUserCities()
    }

    func addRoute(_ route: HikeRoute, toCityWithID cityID: String) {
        if let idx = userCities.firstIndex(where: { $0.id == cityID }) {
            userCities[idx].routes.insert(route, at: 0)
            if selectedCity.id == cityID { selectedCity = userCities[idx] }
            saveUserCities()
        } else if selectedCity.id == cityID {
            // Featured city: update in-memory (not persisted across sessions)
            var updated = selectedCity
            updated.routes.insert(route, at: 0)
            selectedCity = updated
        }
    }

    func deleteUserCity(at offsets: IndexSet) {
        let removed = offsets.map { userCities[$0] }
        userCities.remove(atOffsets: offsets)
        if removed.contains(where: { $0.id == selectedCity.id }) {
            selectedCity = FeaturedCity.all[0]
        }
        saveUserCities()
    }

    // MARK: - Auto Selection

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

    // MARK: - Persistence

    private func saveUserCities() {
        guard let data = try? JSONEncoder().encode(userCities) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func loadUserCities() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let cities = try? JSONDecoder().decode([FeaturedCity].self, from: data) else { return }
        userCities = cities
    }
}

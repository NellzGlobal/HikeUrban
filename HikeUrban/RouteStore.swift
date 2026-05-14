import Foundation
import Combine

class RouteStore: ObservableObject {
    @Published var routes: [HikeRoute] = HikeRoute.detroitSamples

    func add(_ route: HikeRoute) {
        routes.insert(route, at: 0)
    }
}

import Foundation
import Combine

@MainActor
class RouteStore: ObservableObject {
    @Published var routes: [HikeRoute] = HikeRoute.featuredRoutes

    func add(_ route: HikeRoute) {
        routes.insert(route, at: 0)
    }
}

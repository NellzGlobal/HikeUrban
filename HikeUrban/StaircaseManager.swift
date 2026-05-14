import Foundation
import CoreMotion
import Combine

class StaircaseManager: ObservableObject {
    private let pedometer = CMPedometer()

    @Published var floorsAscended: Int  = 0
    @Published var floorsDescended: Int = 0
    @Published var stepCount: Int       = 0
    @Published var isAvailable: Bool    = false

    init() {
        isAvailable = CMPedometer.isFloorCountingAvailable()
    }

    func startCounting(from startDate: Date = Date()) {
        guard CMPedometer.isStepCountingAvailable() else { return }

        pedometer.startUpdates(from: startDate) { [weak self] data, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.stepCount       = data.numberOfSteps.intValue
                self?.floorsAscended  = data.floorsAscended?.intValue  ?? 0
                self?.floorsDescended = data.floorsDescended?.intValue ?? 0
            }
        }
    }

    func stopCounting() {
        pedometer.stopUpdates()
        floorsAscended  = 0
        floorsDescended = 0
        stepCount       = 0
    }

    var estimatedStairsClimbed: Int { floorsAscended * 11 }
}

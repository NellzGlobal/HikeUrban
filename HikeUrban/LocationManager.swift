import Foundation
import CoreLocation
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentSession: HikeSession?
    @Published var isRecording = false
    @Published var elapsedSeconds: Int = 0

    // Road-snapped path built in real-time during recording
    @Published var snappedPath: [CLLocationCoordinate2D] = []
    private var lastSnapLocation: CLLocation?
    private var isSnappingSegment = false
    private let snapThresholdMeters: Double = 75

    private var timer: AnyCancellable?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
        authorizationStatus = manager.authorizationStatus
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func startRecording(name: String = "Detroit Hike") {
        currentSession = HikeSession(name: name, startTime: Date())
        isRecording = true
        elapsedSeconds = 0
        snappedPath = []
        lastSnapLocation = nil
        isSnappingSegment = false
        manager.startUpdatingLocation()

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.elapsedSeconds += 1
            }
    }

    func stopRecording() {
        isRecording = false
        currentSession?.endTime = Date()
        manager.stopUpdatingLocation()
        timer?.cancel()
        timer = nil
    }

    func discardSession() {
        stopRecording()
        currentSession = nil
        elapsedSeconds = 0
        snappedPath = []
        lastSnapLocation = nil
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.location = latest
            if self.isRecording {
                self.currentSession?.locations.append(latest)
                self.processSnap(for: latest)
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            self?.authorizationStatus = manager.authorizationStatus
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    // MARK: - Snap-to-road

    private func processSnap(for location: CLLocation) {
        // Seed the path on the first point
        guard let last = lastSnapLocation else {
            lastSnapLocation = location
            snappedPath.append(location.coordinate)
            return
        }

        // Only snap once the user has moved far enough, and don't queue overlapping requests
        guard !isSnappingSegment,
              location.distance(from: last) >= snapThresholdMeters else { return }

        let from = last.coordinate
        let to   = location.coordinate
        lastSnapLocation = location
        isSnappingSegment = true

        Task { @MainActor in
            let request = MKDirections.Request()
            request.source               = MKMapItem(placemark: MKPlacemark(coordinate: from))
            request.destination          = MKMapItem(placemark: MKPlacemark(coordinate: to))
            request.transportType        = .walking
            request.requestsAlternateRoutes = false

            do {
                let response = try await MKDirections(request: request).calculate()
                if let route = response.routes.first {
                    var coords = [CLLocationCoordinate2D](repeating: .init(), count: route.polyline.pointCount)
                    route.polyline.getCoordinates(&coords, range: NSRange(location: 0, length: route.polyline.pointCount))
                    self.snappedPath.append(contentsOf: coords)
                }
            } catch {
                // Network unavailable or no route — fall back to raw GPS point
                self.snappedPath.append(to)
            }
            self.isSnappingSegment = false
        }
    }
}

# UrbanHike – Phase 1 Setup

## Files
- `UrbanHikeApp.swift` — App entry point
- `Models.swift` — HikeRoute, RouteCoordinate, HikeSession
- `SampleData.swift` — 6 real Detroit routes for testing
- `LocationManager.swift` — CLLocationManager wrapper (ObservableObject)
- `ContentView.swift` — TabView (Explore / Record / Profile)
- `ExploreView.swift` — Map + route list, tap to highlight
- `RouteDetailView.swift` — Full route detail sheet
- `RecordView.swift` — Live GPS recording with live map
- `ProfileView.swift` — Stats + recent hikes

## Xcode Setup

1. Create a new **iOS App** project in Xcode (SwiftUI, Swift)
2. Name it `UrbanHike`
3. Delete the generated `ContentView.swift`
4. Drag all `.swift` files into the project navigator
5. Add to `Info.plist`:
   ```
   NSLocationWhenInUseUsageDescription
   "UrbanHike needs your location to track your hike."
   ```
6. In project settings → Signing & Capabilities → add **Maps** capability

## Requirements
- iOS 17+ (uses new MapKit Map API)
- Xcode 15+

## What's Working
- [x] Detroit map centered on downtown with 6 real routes drawn
- [x] Tap a route card to highlight it on the map
- [x] Long-press a card to open route detail sheet
- [x] Live GPS recording with real-time path drawing
- [x] Session stats (distance, elevation gain, duration timer)
- [x] Save hike sheet with naming
- [x] Profile tab with placeholder stats

## Phase 2 Ideas
- Elevation profile chart (Swift Charts)
- Supabase backend for route storage + user accounts
- Social feed / following
- Staircase counter using altimeter
- Segment leaderboards

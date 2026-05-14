import Foundation
import CoreLocation

// MARK: - All Cities

extension FeaturedCity {
    static let all: [FeaturedCity] = [detroit, newYork, chicago, nashville]

    // MARK: - Detroit

    static let detroit = FeaturedCity(
        id: "detroit",
        name: "Detroit",
        state: "MI",
        emoji: "🏭",
        tagline: "Grit, Renaissance & Riverwalk",
        center: CLLocationCoordinate2D(latitude: 42.3314, longitude: -83.0458),
        routes: HikeRoute.featuredRoutes,
        neighborhoods: [
            WalkableNeighborhood(
                name: "Downtown", walkScore: 92,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 42.3400, longitude: -83.0580),
                    CLLocationCoordinate2D(latitude: 42.3400, longitude: -83.0290),
                    CLLocationCoordinate2D(latitude: 42.3280, longitude: -83.0290),
                    CLLocationCoordinate2D(latitude: 42.3280, longitude: -83.0580),
                ],
                highlights: ["Hart Plaza", "Campus Martius", "Riverfront", "Woodward Ave"],
                notes: "Detroit's most walkable area. Dense retail, dining, riverfront access, and major transit hub."
            ),
            WalkableNeighborhood(
                name: "Midtown", walkScore: 85,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 42.3720, longitude: -83.0780),
                    CLLocationCoordinate2D(latitude: 42.3720, longitude: -83.0540),
                    CLLocationCoordinate2D(latitude: 42.3480, longitude: -83.0540),
                    CLLocationCoordinate2D(latitude: 42.3480, longitude: -83.0780),
                ],
                highlights: ["DIA", "Wayne State", "MOCAD", "Cass Corridor"],
                notes: "Arts, culture, and student energy. Well-connected grid with good lighting and foot traffic."
            ),
            WalkableNeighborhood(
                name: "Corktown", walkScore: 78,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 42.3390, longitude: -83.0850),
                    CLLocationCoordinate2D(latitude: 42.3390, longitude: -83.0640),
                    CLLocationCoordinate2D(latitude: 42.3260, longitude: -83.0640),
                    CLLocationCoordinate2D(latitude: 42.3260, longitude: -83.0850),
                ],
                highlights: ["Michigan Central Station", "Roosevelt Park", "Michigan Ave dining"],
                notes: "Detroit's oldest neighbourhood is booming. Tight grid of brick streets, great cafes, Ford's new campus."
            ),
            WalkableNeighborhood(
                name: "Eastern Market", walkScore: 81,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 42.3560, longitude: -83.0470),
                    CLLocationCoordinate2D(latitude: 42.3560, longitude: -83.0290),
                    CLLocationCoordinate2D(latitude: 42.3420, longitude: -83.0290),
                    CLLocationCoordinate2D(latitude: 42.3420, longitude: -83.0470),
                ],
                highlights: ["Shed 5 murals", "Saturday market", "Gratiot corridor"],
                notes: "One of Detroit's most vibrant daytime walkable areas. Best on Saturday when the market is running."
            ),
            WalkableNeighborhood(
                name: "Rivertown", walkScore: 74,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 42.3360, longitude: -83.0290),
                    CLLocationCoordinate2D(latitude: 42.3360, longitude: -83.0130),
                    CLLocationCoordinate2D(latitude: 42.3270, longitude: -83.0130),
                    CLLocationCoordinate2D(latitude: 42.3270, longitude: -83.0290),
                ],
                highlights: ["Riverwalk east extension", "Dequindre Cut south end", "Whiskey Island"],
                notes: "A quieter stretch of the Riverwalk east of Downtown. Great for evening walks with river views."
            ),
            WalkableNeighborhood(
                name: "New Center", walkScore: 63,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 42.3860, longitude: -83.0960),
                    CLLocationCoordinate2D(latitude: 42.3860, longitude: -83.0720),
                    CLLocationCoordinate2D(latitude: 42.3700, longitude: -83.0720),
                    CLLocationCoordinate2D(latitude: 42.3700, longitude: -83.0960),
                ],
                highlights: ["Fisher Building", "Grand Boulevard"],
                notes: "Grand architecture with Albert Kahn buildings throughout. Walkable on main corridors."
            ),
            WalkableNeighborhood(
                name: "Greektown", walkScore: 88,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 42.3380, longitude: -83.0430),
                    CLLocationCoordinate2D(latitude: 42.3380, longitude: -83.0280),
                    CLLocationCoordinate2D(latitude: 42.3290, longitude: -83.0280),
                    CLLocationCoordinate2D(latitude: 42.3290, longitude: -83.0430),
                ],
                highlights: ["Monroe Street", "Bricktown", "Little Caesars Arena nearby"],
                notes: "Entertainment district with dense restaurants and nightlife. Very walkable evenings and weekends."
            ),
            WalkableNeighborhood(
                name: "Mexicantown", walkScore: 66,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 42.3270, longitude: -83.1050),
                    CLLocationCoordinate2D(latitude: 42.3270, longitude: -83.0870),
                    CLLocationCoordinate2D(latitude: 42.3170, longitude: -83.0870),
                    CLLocationCoordinate2D(latitude: 42.3170, longitude: -83.1050),
                ],
                highlights: ["Vernor Highway restaurants", "Patton Park", "Ambassador Bridge views"],
                notes: "Authentic neighbourhood with great food and culture. Walk score limited by distance from core."
            ),
        ]
    )

    // MARK: - New York City

    static let newYork = FeaturedCity(
        id: "nyc",
        name: "New York",
        state: "NY",
        emoji: "🗽",
        tagline: "The city that never stops walking",
        center: CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855),
        routes: [
            HikeRoute(
                id: UUID(),
                name: "Brooklyn Bridge to DUMBO",
                description: "Cross the iconic Brooklyn Bridge on the pedestrian path, drop into the cobblestoned streets of DUMBO, and finish at the waterfront park with skyline views of Manhattan.",
                neighborhood: "Lower Manhattan / DUMBO",
                difficulty: .easy,
                supportedModes: [.walk, .run],
                coordinates: [
                    RouteCoordinate(latitude: 40.7061, longitude: -73.9969, elevationFt: 8),
                    RouteCoordinate(latitude: 40.7053, longitude: -73.9941, elevationFt: 90),
                    RouteCoordinate(latitude: 40.7039, longitude: -73.9904, elevationFt: 50),
                    RouteCoordinate(latitude: 40.7033, longitude: -73.9882, elevationFt: 10),
                    RouteCoordinate(latitude: 40.7019, longitude: -73.9872, elevationFt: 8),
                ],
                distanceMiles: 2.1,
                elevationGainFt: 130,
                estimatedMinutes: 45,
                rating: 4.9,
                reviewCount: 1840,
                isEditorsPick: true,
                tags: ["iconic", "skyline", "bridge", "waterfront"],
                accessibility: AccessibilityInfo(
                    isWheelchairFriendly: false,
                    isStrollerFriendly: false,
                    isLowImpact: false,
                    hasStairSections: 2,
                    surfaceType: .paved,
                    maxGradePercent: 8.0,
                    notes: "Bridge ramp has moderate incline. DUMBO streets are cobblestone."
                ),
                shotPins: [
                    ShotPin(
                        id: UUID(),
                        title: "Bridge Mid-Span Looking West",
                        shootingNotes: "Frame lower Manhattan between the iconic bridge cables. Shoot at golden hour for warm light on the skyline.",
                        coordinate: RouteCoordinate(latitude: 40.7053, longitude: -73.9941, elevationFt: 90),
                        bestTimeOfDay: .goldenHourEvening,
                        suggestedFocalLength: "24–50mm",
                        tags: [.architecture, .water]
                    ),
                ],
                historicalPoints: [
                    HistoricalPoint(
                        id: UUID(),
                        title: "Brooklyn Bridge Opens — 1883",
                        era: "1883",
                        description: "The longest suspension bridge in the world when it opened. Took 14 years to build and cost the lives of 27 workers, including the designer's son.",
                        coordinate: RouteCoordinate(latitude: 40.7053, longitude: -73.9941, elevationFt: 90)
                    ),
                ],
                darkSafety: DarkSafetyRating(
                    overallScore: 4,
                    lightingQuality: 4,
                    footTraffic: 4,
                    communityNotes: "Bridge walkway is well lit and busy around the clock. DUMBO quieter after midnight.",
                    recommendedAfterDark: true
                )
            ),
            HikeRoute(
                id: UUID(),
                name: "The High Line",
                description: "Walk New York's elevated park built on a disused freight railway. One mile of gardens, art installations, and Hudson River views above the streets of Chelsea and Hudson Yards.",
                neighborhood: "Chelsea / Hudson Yards",
                difficulty: .easy,
                supportedModes: [.walk, .run],
                coordinates: [
                    RouteCoordinate(latitude: 40.7398, longitude: -74.0048, elevationFt: 40),
                    RouteCoordinate(latitude: 40.7440, longitude: -74.0044, elevationFt: 42),
                    RouteCoordinate(latitude: 40.7474, longitude: -74.0040, elevationFt: 43),
                    RouteCoordinate(latitude: 40.7521, longitude: -74.0027, elevationFt: 40),
                    RouteCoordinate(latitude: 40.7527, longitude: -74.0024, elevationFt: 38),
                ],
                distanceMiles: 1.45,
                elevationGainFt: 15,
                estimatedMinutes: 35,
                rating: 4.7,
                reviewCount: 2310,
                isEditorsPick: true,
                tags: ["elevated", "gardens", "art", "Hudson River"],
                accessibility: AccessibilityInfo(
                    isWheelchairFriendly: true,
                    isStrollerFriendly: true,
                    isLowImpact: true,
                    hasStairSections: 0,
                    surfaceType: .paved,
                    maxGradePercent: 2.0,
                    notes: "Elevators at most access points. Fully accessible path throughout."
                ),
                shotPins: [
                    ShotPin(
                        id: UUID(),
                        title: "10th Ave Square — Looking South",
                        shootingNotes: "The amphitheatre-style overlook frames 10th Ave like a living painting. Shoot the yellow cabs streaming below with a telephoto.",
                        coordinate: RouteCoordinate(latitude: 40.7445, longitude: -74.0042, elevationFt: 42),
                        bestTimeOfDay: .goldenHourEvening,
                        suggestedFocalLength: "85–200mm",
                        tags: [.abstract, .architecture]
                    ),
                ],
                historicalPoints: [
                    HistoricalPoint(
                        id: UUID(),
                        title: "West Side Line — 1934",
                        era: "1934–1980",
                        description: "Built to eliminate grade-level crossings that killed so many pedestrians it was called 'Death Avenue'. The last train ran in 1980. The park opened in 2009.",
                        coordinate: RouteCoordinate(latitude: 40.7398, longitude: -74.0048, elevationFt: 40)
                    ),
                ],
                darkSafety: DarkSafetyRating(
                    overallScore: 5,
                    lightingQuality: 5,
                    footTraffic: 5,
                    communityNotes: "Extremely well lit and busy every night. One of the safest walks in the city.",
                    recommendedAfterDark: true
                )
            ),
            HikeRoute(
                id: UUID(),
                name: "Central Park Reservoir Loop",
                description: "Circle the Jacqueline Kennedy Onassis Reservoir — a 106-acre lake at the heart of Central Park. Packed with joggers and walkers, with skyline views in all directions.",
                neighborhood: "Upper West / East Side",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike],
                coordinates: [
                    RouteCoordinate(latitude: 40.7840, longitude: -73.9644, elevationFt: 56),
                    RouteCoordinate(latitude: 40.7870, longitude: -73.9584, elevationFt: 58),
                    RouteCoordinate(latitude: 40.7884, longitude: -73.9638, elevationFt: 56),
                    RouteCoordinate(latitude: 40.7851, longitude: -73.9695, elevationFt: 54),
                    RouteCoordinate(latitude: 40.7840, longitude: -73.9644, elevationFt: 56),
                ],
                distanceMiles: 1.58,
                elevationGainFt: 20,
                estimatedMinutes: 32,
                rating: 4.8,
                reviewCount: 987,
                isEditorsPick: false,
                tags: ["park", "loop", "skyline", "running"],
                accessibility: AccessibilityInfo(
                    isWheelchairFriendly: false,
                    isStrollerFriendly: false,
                    isLowImpact: true,
                    hasStairSections: 0,
                    surfaceType: .gravel,
                    maxGradePercent: 3.0,
                    notes: "Crushed gravel path. Gentle rolling terrain."
                ),
                shotPins: [],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(
                    overallScore: 3,
                    lightingQuality: 3,
                    footTraffic: 3,
                    communityNotes: "Busy during daylight. Fewer people after dark — use the lit perimeter roads instead.",
                    recommendedAfterDark: false
                )
            ),
        ],
        neighborhoods: [
            WalkableNeighborhood(
                name: "Lower Manhattan", walkScore: 98,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 40.7205, longitude: -74.0197),
                    CLLocationCoordinate2D(latitude: 40.7205, longitude: -74.0024),
                    CLLocationCoordinate2D(latitude: 40.7018, longitude: -74.0024),
                    CLLocationCoordinate2D(latitude: 40.7018, longitude: -74.0197),
                ],
                highlights: ["Wall Street", "Battery Park", "Fulton Center", "9/11 Memorial"],
                notes: "The most walkable corner of one of the world's most walkable cities. Transit is everywhere."
            ),
            WalkableNeighborhood(
                name: "Chelsea / High Line", walkScore: 97,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 40.7527, longitude: -74.0070),
                    CLLocationCoordinate2D(latitude: 40.7527, longitude: -73.9940),
                    CLLocationCoordinate2D(latitude: 40.7390, longitude: -73.9940),
                    CLLocationCoordinate2D(latitude: 40.7390, longitude: -74.0070),
                ],
                highlights: ["High Line park", "Chelsea Market", "Hudson Yards", "Gallery district"],
                notes: "Transformed by the High Line. Dense, flat, extremely walkable with art galleries at street level."
            ),
            WalkableNeighborhood(
                name: "DUMBO", walkScore: 90,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 40.7075, longitude: -73.9960),
                    CLLocationCoordinate2D(latitude: 40.7075, longitude: -73.9800),
                    CLLocationCoordinate2D(latitude: 40.6970, longitude: -73.9800),
                    CLLocationCoordinate2D(latitude: 40.6970, longitude: -73.9960),
                ],
                highlights: ["Brooklyn Bridge Park", "Jane's Carousel", "Manhattan Bridge arch", "Main St cobblestones"],
                notes: "Down Under the Manhattan Bridge Overpass — cobblestone streets and the best Manhattan skyline views."
            ),
            WalkableNeighborhood(
                name: "Upper West Side", walkScore: 96,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 40.7980, longitude: -73.9700),
                    CLLocationCoordinate2D(latitude: 40.7980, longitude: -73.9535),
                    CLLocationCoordinate2D(latitude: 40.7750, longitude: -73.9535),
                    CLLocationCoordinate2D(latitude: 40.7750, longitude: -73.9700),
                ],
                highlights: ["Central Park west edge", "Broadway restaurants", "American Museum of Natural History"],
                notes: "Classic NYC residential walkability. Everything within a short walk, with the park right there."
            ),
        ]
    )

    // MARK: - Chicago

    static let chicago = FeaturedCity(
        id: "chicago",
        name: "Chicago",
        state: "IL",
        emoji: "🌬️",
        tagline: "Architecture, lakefront & the 606",
        center: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298),
        routes: [
            HikeRoute(
                id: UUID(),
                name: "Chicago Riverwalk",
                description: "Stroll along the Chicago River through the heart of the Loop, surrounded by a canyon of iconic skyscrapers. The 1.25-mile Riverwalk is lined with restaurants, kayak launches, and public art.",
                neighborhood: "The Loop",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike, .scooter],
                coordinates: [
                    RouteCoordinate(latitude: 41.8878, longitude: -87.6277, elevationFt: 593),
                    RouteCoordinate(latitude: 41.8875, longitude: -87.6250, elevationFt: 593),
                    RouteCoordinate(latitude: 41.8869, longitude: -87.6214, elevationFt: 593),
                    RouteCoordinate(latitude: 41.8866, longitude: -87.6186, elevationFt: 593),
                    RouteCoordinate(latitude: 41.8864, longitude: -87.6150, elevationFt: 593),
                ],
                distanceMiles: 1.5,
                elevationGainFt: 8,
                estimatedMinutes: 30,
                rating: 4.8,
                reviewCount: 1420,
                isEditorsPick: true,
                tags: ["river", "architecture", "flat", "skyline"],
                accessibility: AccessibilityInfo(
                    isWheelchairFriendly: true,
                    isStrollerFriendly: true,
                    isLowImpact: true,
                    hasStairSections: 0,
                    surfaceType: .paved,
                    maxGradePercent: 1.0,
                    notes: "Fully paved and flat. Ramp access from all major bridge crossings."
                ),
                shotPins: [
                    ShotPin(
                        id: UUID(),
                        title: "State St Bridge — Skyscraper Canyon",
                        shootingNotes: "Stand on the Riverwalk and shoot straight up the river corridor. The buildings converge like a canyon. Blue hour gives the glass towers an electric glow.",
                        coordinate: RouteCoordinate(latitude: 41.8869, longitude: -87.6278, elevationFt: 593),
                        bestTimeOfDay: .bluehour,
                        suggestedFocalLength: "16–24mm",
                        tags: [.architecture, .abstract]
                    ),
                ],
                historicalPoints: [
                    HistoricalPoint(
                        id: UUID(),
                        title: "The River Is Reversed — 1900",
                        era: "1900",
                        description: "Engineers reversed the flow of the Chicago River away from Lake Michigan to prevent sewage contamination — one of the greatest engineering feats of the era.",
                        coordinate: RouteCoordinate(latitude: 41.8872, longitude: -87.6270, elevationFt: 593)
                    ),
                ],
                darkSafety: DarkSafetyRating(
                    overallScore: 5,
                    lightingQuality: 5,
                    footTraffic: 4,
                    communityNotes: "Extremely well lit. Active restaurants keep people around until late.",
                    recommendedAfterDark: true
                )
            ),
            HikeRoute(
                id: UUID(),
                name: "Millennium Park to Museum Campus",
                description: "Start at the Bean, walk through Grant Park past Buckingham Fountain, and finish at the Museum Campus on Lake Michigan — home to the Field Museum, Shedd Aquarium, and Adler Planetarium.",
                neighborhood: "The Loop / Museum Campus",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike],
                coordinates: [
                    RouteCoordinate(latitude: 41.8826, longitude: -87.6233, elevationFt: 595),
                    RouteCoordinate(latitude: 41.8800, longitude: -87.6196, elevationFt: 595),
                    RouteCoordinate(latitude: 41.8759, longitude: -87.6188, elevationFt: 596),
                    RouteCoordinate(latitude: 41.8710, longitude: -87.6160, elevationFt: 593),
                    RouteCoordinate(latitude: 41.8654, longitude: -87.6143, elevationFt: 592),
                ],
                distanceMiles: 2.2,
                elevationGainFt: 22,
                estimatedMinutes: 45,
                rating: 4.7,
                reviewCount: 892,
                isEditorsPick: true,
                tags: ["lakefront", "park", "museums", "fountain"],
                accessibility: AccessibilityInfo(
                    isWheelchairFriendly: true,
                    isStrollerFriendly: true,
                    isLowImpact: true,
                    hasStairSections: 0,
                    surfaceType: .paved,
                    maxGradePercent: 2.0,
                    notes: "Paved paths throughout. Very accessible."
                ),
                shotPins: [
                    ShotPin(
                        id: UUID(),
                        title: "Cloud Gate (The Bean) — Reflection",
                        shootingNotes: "Get low and shoot the skyline reflected in the curved surface. Early morning for no crowds. The distorted city-in-the-bean effect is unique.",
                        coordinate: RouteCoordinate(latitude: 41.8826, longitude: -87.6233, elevationFt: 595),
                        bestTimeOfDay: .goldenHourMorning,
                        suggestedFocalLength: "16–35mm",
                        tags: [.abstract, .architecture]
                    ),
                ],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(
                    overallScore: 4,
                    lightingQuality: 4,
                    footTraffic: 3,
                    communityNotes: "Well lit through Grant Park. Museum Campus quieter at night.",
                    recommendedAfterDark: true
                )
            ),
            HikeRoute(
                id: UUID(),
                name: "606 Trail — Bloomingdale Trail",
                description: "Chicago's answer to the High Line: a converted elevated rail corridor running east-west through Wicker Park and Bucktown. Lined with murals and overlooking Chicago's residential rooftops.",
                neighborhood: "Wicker Park / Bucktown",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike, .scooter],
                coordinates: [
                    RouteCoordinate(latitude: 41.9148, longitude: -87.6846, elevationFt: 608),
                    RouteCoordinate(latitude: 41.9150, longitude: -87.6751, elevationFt: 609),
                    RouteCoordinate(latitude: 41.9151, longitude: -87.6671, elevationFt: 610),
                    RouteCoordinate(latitude: 41.9150, longitude: -87.6590, elevationFt: 611),
                    RouteCoordinate(latitude: 41.9148, longitude: -87.6453, elevationFt: 610),
                ],
                distanceMiles: 2.7,
                elevationGainFt: 18,
                estimatedMinutes: 55,
                rating: 4.6,
                reviewCount: 634,
                isEditorsPick: false,
                tags: ["rail-trail", "elevated", "murals", "residential"],
                accessibility: AccessibilityInfo(
                    isWheelchairFriendly: true,
                    isStrollerFriendly: true,
                    isLowImpact: true,
                    hasStairSections: 0,
                    surfaceType: .paved,
                    maxGradePercent: 2.0,
                    notes: "Ramp access at all entry points. Smooth paved surface throughout."
                ),
                shotPins: [
                    ShotPin(
                        id: UUID(),
                        title: "Damen Ave — Rooftop Panorama",
                        shootingNotes: "From the trail at Damen, you're above the rooftops. Shoot the Chicago skyline peeking above the neighbourhood. Perfect at blue hour when the city lights up.",
                        coordinate: RouteCoordinate(latitude: 41.9150, longitude: -87.6765, elevationFt: 609),
                        bestTimeOfDay: .bluehour,
                        suggestedFocalLength: "35–85mm",
                        tags: [.architecture, .abstract]
                    ),
                ],
                historicalPoints: [
                    HistoricalPoint(
                        id: UUID(),
                        title: "Bloomingdale Line — 1870s",
                        era: "1870s–2000s",
                        description: "The rail line carried freight to Chicago's north-side factories for over a century. Abandoned in the early 2000s, it was converted to the 606 Trail which opened in 2015.",
                        coordinate: RouteCoordinate(latitude: 41.9148, longitude: -87.6846, elevationFt: 608)
                    ),
                ],
                darkSafety: DarkSafetyRating(
                    overallScore: 4,
                    lightingQuality: 4,
                    footTraffic: 3,
                    communityNotes: "Good lighting along most of the trail. Active neighbourhood below keeps it feeling safe.",
                    recommendedAfterDark: true
                )
            ),
        ],
        neighborhoods: [
            WalkableNeighborhood(
                name: "The Loop", walkScore: 97,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 41.8920, longitude: -87.6420),
                    CLLocationCoordinate2D(latitude: 41.8920, longitude: -87.6195),
                    CLLocationCoordinate2D(latitude: 41.8720, longitude: -87.6195),
                    CLLocationCoordinate2D(latitude: 41.8720, longitude: -87.6420),
                ],
                highlights: ["Riverwalk", "Millennium Park", "Art Institute", "Chicago Theatre"],
                notes: "Chicago's iconic downtown. World-class architecture, transit, and culture in every direction."
            ),
            WalkableNeighborhood(
                name: "Wicker Park", walkScore: 93,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 41.9130, longitude: -87.6900),
                    CLLocationCoordinate2D(latitude: 41.9130, longitude: -87.6680),
                    CLLocationCoordinate2D(latitude: 41.8990, longitude: -87.6680),
                    CLLocationCoordinate2D(latitude: 41.8990, longitude: -87.6900),
                ],
                highlights: ["606 Trail", "Milwaukee Ave", "independent shops", "live music venues"],
                notes: "Chicago's creative hub. The 606 trail runs overhead while indie shops and restaurants fill the streets below."
            ),
            WalkableNeighborhood(
                name: "Lincoln Park", walkScore: 92,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 41.9310, longitude: -87.6620),
                    CLLocationCoordinate2D(latitude: 41.9310, longitude: -87.6400),
                    CLLocationCoordinate2D(latitude: 41.9130, longitude: -87.6400),
                    CLLocationCoordinate2D(latitude: 41.9130, longitude: -87.6620),
                ],
                highlights: ["Lincoln Park Zoo (free)", "lakefront path", "Armitage Ave shopping"],
                notes: "Classic Chicago neighbourhood with free zoo access and the lakefront path running the whole east edge."
            ),
            WalkableNeighborhood(
                name: "River North", walkScore: 94,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 41.9020, longitude: -87.6530),
                    CLLocationCoordinate2D(latitude: 41.9020, longitude: -87.6270),
                    CLLocationCoordinate2D(latitude: 41.8880, longitude: -87.6270),
                    CLLocationCoordinate2D(latitude: 41.8880, longitude: -87.6530),
                ],
                highlights: ["Gallery district", "restaurant row", "Merchandise Mart", "riverwalk access"],
                notes: "Gallery district by day, restaurant hub by night. Connects seamlessly to the Riverwalk."
            ),
        ]
    )

    // MARK: - Nashville

    static let nashville = FeaturedCity(
        id: "nashville",
        name: "Nashville",
        state: "TN",
        emoji: "🎸",
        tagline: "Music, history & the Gulch",
        center: CLLocationCoordinate2D(latitude: 36.1627, longitude: -86.7816),
        routes: [
            HikeRoute(
                id: UUID(),
                name: "The Gulch to 12 South",
                description: "Walk from Nashville's trendy Gulch neighbourhood south through Edgehill and into 12 South — a tree-lined strip of local boutiques, coffee shops, and the iconic I Believe in Nashville mural.",
                neighborhood: "The Gulch / 12 South",
                difficulty: .moderate,
                supportedModes: [.walk, .run],
                coordinates: [
                    RouteCoordinate(latitude: 36.1487, longitude: -86.7953, elevationFt: 520),
                    RouteCoordinate(latitude: 36.1450, longitude: -86.7945, elevationFt: 522),
                    RouteCoordinate(latitude: 36.1380, longitude: -86.7938, elevationFt: 528),
                    RouteCoordinate(latitude: 36.1290, longitude: -86.7935, elevationFt: 530),
                    RouteCoordinate(latitude: 36.1248, longitude: -86.7942, elevationFt: 518),
                ],
                distanceMiles: 2.3,
                elevationGainFt: 65,
                estimatedMinutes: 50,
                rating: 4.5,
                reviewCount: 318,
                isEditorsPick: true,
                tags: ["murals", "coffee", "boutiques", "residential"],
                accessibility: AccessibilityInfo(
                    isWheelchairFriendly: false,
                    isStrollerFriendly: true,
                    isLowImpact: false,
                    hasStairSections: 0,
                    surfaceType: .paved,
                    maxGradePercent: 6.0,
                    notes: "Rolling hills — moderately hilly through Edgehill. 12 South itself is flat."
                ),
                shotPins: [
                    ShotPin(
                        id: UUID(),
                        title: "I Believe in Nashville Mural",
                        shootingNotes: "Nashville's most photographed mural on 12th Ave S. Morning light hits it from the east. Get there early before the crowds line up for photos.",
                        coordinate: RouteCoordinate(latitude: 36.1248, longitude: -86.7942, elevationFt: 518),
                        bestTimeOfDay: .goldenHourMorning,
                        suggestedFocalLength: "24–35mm",
                        tags: [.streetArt, .portrait]
                    ),
                ],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(
                    overallScore: 4,
                    lightingQuality: 4,
                    footTraffic: 3,
                    communityNotes: "12 South lively until late. The Edgehill section is quieter — stick to main roads at night.",
                    recommendedAfterDark: true
                )
            ),
            HikeRoute(
                id: UUID(),
                name: "Germantown Heritage Walk",
                description: "Nashville's oldest neighbourhood, just north of downtown. Walk 5th Ave N through beautifully restored Victorian-era brick houses, indie restaurants, and the Nashville Farmer's Market.",
                neighborhood: "Germantown",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike],
                coordinates: [
                    RouteCoordinate(latitude: 36.1820, longitude: -86.7903, elevationFt: 490),
                    RouteCoordinate(latitude: 36.1830, longitude: -86.7882, elevationFt: 492),
                    RouteCoordinate(latitude: 36.1850, longitude: -86.7866, elevationFt: 493),
                    RouteCoordinate(latitude: 36.1835, longitude: -86.7848, elevationFt: 491),
                    RouteCoordinate(latitude: 36.1810, longitude: -86.7862, elevationFt: 490),
                    RouteCoordinate(latitude: 36.1820, longitude: -86.7903, elevationFt: 490),
                ],
                distanceMiles: 1.8,
                elevationGainFt: 30,
                estimatedMinutes: 38,
                rating: 4.6,
                reviewCount: 214,
                isEditorsPick: true,
                tags: ["heritage", "Victorian", "farmer's market", "dining"],
                accessibility: AccessibilityInfo(
                    isWheelchairFriendly: true,
                    isStrollerFriendly: true,
                    isLowImpact: true,
                    hasStairSections: 0,
                    surfaceType: .paved,
                    maxGradePercent: 3.0,
                    notes: "Flat to gently rolling. Mostly paved sidewalks."
                ),
                shotPins: [
                    ShotPin(
                        id: UUID(),
                        title: "5th Ave N Brick Streetscape",
                        shootingNotes: "The restored Victorian row houses on 5th Ave photograph beautifully. Use a medium focal length to compress the perspective. Overcast days give the brick a rich, saturated look.",
                        coordinate: RouteCoordinate(latitude: 36.1835, longitude: -86.7870, elevationFt: 492),
                        bestTimeOfDay: .anytime,
                        suggestedFocalLength: "50–85mm",
                        tags: [.architecture]
                    ),
                ],
                historicalPoints: [
                    HistoricalPoint(
                        id: UUID(),
                        title: "Germantown — Founded 1853",
                        era: "1853",
                        description: "German immigrants settled here in the 1850s, building the dense brick workers' cottages that still line the streets. It became Nashville's first historic preservation district.",
                        coordinate: RouteCoordinate(latitude: 36.1830, longitude: -86.7882, elevationFt: 492)
                    ),
                ],
                darkSafety: DarkSafetyRating(
                    overallScore: 4,
                    lightingQuality: 4,
                    footTraffic: 3,
                    communityNotes: "Well lit main streets. Active restaurant scene keeps it lively most evenings.",
                    recommendedAfterDark: true
                )
            ),
            HikeRoute(
                id: UUID(),
                name: "Shelby Park Greenway Loop",
                description: "An accessible greenway loop around Shelby Lake in East Nashville. Flat, shaded, and popular with locals — a peaceful escape from the city with wildlife, fishing piers, and picnic areas.",
                neighborhood: "East Nashville",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike, .scooter],
                coordinates: [
                    RouteCoordinate(latitude: 36.1783, longitude: -86.7342, elevationFt: 450),
                    RouteCoordinate(latitude: 36.1760, longitude: -86.7300, elevationFt: 449),
                    RouteCoordinate(latitude: 36.1730, longitude: -86.7260, elevationFt: 448),
                    RouteCoordinate(latitude: 36.1720, longitude: -86.7240, elevationFt: 447),
                    RouteCoordinate(latitude: 36.1745, longitude: -86.7280, elevationFt: 449),
                    RouteCoordinate(latitude: 36.1783, longitude: -86.7342, elevationFt: 450),
                ],
                distanceMiles: 2.5,
                elevationGainFt: 15,
                estimatedMinutes: 50,
                rating: 4.4,
                reviewCount: 176,
                isEditorsPick: false,
                tags: ["greenway", "lake", "flat", "wildlife"],
                accessibility: AccessibilityInfo(
                    isWheelchairFriendly: true,
                    isStrollerFriendly: true,
                    isLowImpact: true,
                    hasStairSections: 0,
                    surfaceType: .paved,
                    maxGradePercent: 1.5,
                    notes: "Fully paved, completely flat loop. Great for all abilities."
                ),
                shotPins: [],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(
                    overallScore: 3,
                    lightingQuality: 3,
                    footTraffic: 2,
                    communityNotes: "Peaceful but isolated at night. Best during daylight hours.",
                    recommendedAfterDark: false
                )
            ),
        ],
        neighborhoods: [
            WalkableNeighborhood(
                name: "The Gulch", walkScore: 82,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 36.1560, longitude: -86.8050),
                    CLLocationCoordinate2D(latitude: 36.1560, longitude: -86.7900),
                    CLLocationCoordinate2D(latitude: 36.1430, longitude: -86.7900),
                    CLLocationCoordinate2D(latitude: 36.1430, longitude: -86.8050),
                ],
                highlights: ["rooftop bars", "boutique hotels", "murals", "Whole Foods / walkable retail"],
                notes: "Nashville's most walkable urban neighbourhood. LEED-certified buildings and dense mixed-use streets."
            ),
            WalkableNeighborhood(
                name: "Germantown", walkScore: 78,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 36.1890, longitude: -86.7990),
                    CLLocationCoordinate2D(latitude: 36.1890, longitude: -86.7840),
                    CLLocationCoordinate2D(latitude: 36.1740, longitude: -86.7840),
                    CLLocationCoordinate2D(latitude: 36.1740, longitude: -86.7990),
                ],
                highlights: ["5th Ave restaurants", "Nashville Farmer's Market", "Victorian architecture"],
                notes: "Charming historic district with walkable restaurant strip and easy access to downtown."
            ),
            WalkableNeighborhood(
                name: "East Nashville", walkScore: 73,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 36.1830, longitude: -86.7620),
                    CLLocationCoordinate2D(latitude: 36.1830, longitude: -86.7370),
                    CLLocationCoordinate2D(latitude: 36.1590, longitude: -86.7370),
                    CLLocationCoordinate2D(latitude: 36.1590, longitude: -86.7620),
                ],
                highlights: ["Five Points", "Shelby Park", "dive bars & coffee", "creative community"],
                notes: "Eclectic and walkable around Five Points. More spread out elsewhere but cycling-friendly throughout."
            ),
            WalkableNeighborhood(
                name: "12 South", walkScore: 88,
                coordinates: [
                    CLLocationCoordinate2D(latitude: 36.1340, longitude: -86.8090),
                    CLLocationCoordinate2D(latitude: 36.1340, longitude: -86.7860),
                    CLLocationCoordinate2D(latitude: 36.1140, longitude: -86.7860),
                    CLLocationCoordinate2D(latitude: 36.1140, longitude: -86.8090),
                ],
                highlights: ["12th Ave S shops", "I Believe in Nashville mural", "brunch scene", "Sevier Park"],
                notes: "Nashville's most Instagram-friendly street. Dense, tree-lined, and very pedestrian-friendly."
            ),
        ]
    )
}

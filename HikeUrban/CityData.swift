import Foundation
import CoreLocation

// MARK: - All Cities

extension FeaturedCity {
    static let all: [FeaturedCity] = [detroit, newYork, chicago, nashville, cleveland, windsor, londonON, parisON, toronto]

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

    // MARK: - Cleveland

    static let cleveland = FeaturedCity(
        id: "cleveland",
        name: "Cleveland",
        state: "OH",
        emoji: "🎸",
        tagline: "Rock Hall, river trails & Ohio City",
        center: CLLocationCoordinate2D(latitude: 41.4993, longitude: -81.6944),
        routes: [
            HikeRoute(
                id: UUID(),
                name: "Flats East Bank & Towpath",
                description: "Walk the Cuyahoga River through the historic Flats, where industrial heritage meets craft breweries and a revived riverfront. Connect to the towpath trail for river views and wildlife.",
                neighborhood: "The Flats",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike],
                coordinates: [
                    RouteCoordinate(latitude: 41.4962, longitude: -81.6955, elevationFt: 580),
                    RouteCoordinate(latitude: 41.4945, longitude: -81.6962, elevationFt: 578),
                    RouteCoordinate(latitude: 41.4920, longitude: -81.6975, elevationFt: 577),
                    RouteCoordinate(latitude: 41.4900, longitude: -81.6985, elevationFt: 576),
                ],
                distanceMiles: 2.0,
                elevationGainFt: 28,
                estimatedMinutes: 42,
                rating: 4.5,
                reviewCount: 312,
                isEditorsPick: true,
                tags: ["river", "industrial", "brewery", "towpath"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .paved, maxGradePercent: 2.0, notes: "Flat paved path along the river."),
                shotPins: [
                    ShotPin(id: UUID(), title: "Cuyahoga River at Dusk", shootingNotes: "The old lift bridges and brewery lights reflect in the river. Best 20 min after sunset when the city glow kicks in.", coordinate: RouteCoordinate(latitude: 41.4945, longitude: -81.6962, elevationFt: 578), bestTimeOfDay: .goldenHourEvening, suggestedFocalLength: "35–85mm", tags: [.water, .industrial]),
                ],
                historicalPoints: [
                    HistoricalPoint(id: UUID(), title: "Cuyahoga River Fire — 1969", era: "1969", description: "The river was so polluted it caught fire multiple times. The 1969 fire shocked the nation and directly inspired the Clean Water Act. The river today is clean enough for kayaking.", coordinate: RouteCoordinate(latitude: 41.4920, longitude: -81.6975, elevationFt: 577)),
                ],
                darkSafety: DarkSafetyRating(overallScore: 4, lightingQuality: 4, footTraffic: 3, communityNotes: "Well lit along the riverfront. Active bar scene keeps foot traffic up most evenings.", recommendedAfterDark: true)
            ),
            HikeRoute(
                id: UUID(),
                name: "Ohio City & West Side Market",
                description: "Explore Cleveland's most walkable neighbourhood — a dense grid of Victorian homes, craft coffee shops, and the magnificent West Side Market, a century-old indoor market under a soaring vaulted ceiling.",
                neighborhood: "Ohio City",
                difficulty: .easy,
                supportedModes: [.walk, .run],
                coordinates: [
                    RouteCoordinate(latitude: 41.4851, longitude: -81.7031, elevationFt: 620),
                    RouteCoordinate(latitude: 41.4865, longitude: -81.7010, elevationFt: 621),
                    RouteCoordinate(latitude: 41.4880, longitude: -81.6990, elevationFt: 622),
                    RouteCoordinate(latitude: 41.4895, longitude: -81.6975, elevationFt: 620),
                    RouteCoordinate(latitude: 41.4851, longitude: -81.7031, elevationFt: 620),
                ],
                distanceMiles: 1.8,
                elevationGainFt: 35,
                estimatedMinutes: 38,
                rating: 4.7,
                reviewCount: 428,
                isEditorsPick: true,
                tags: ["market", "Victorian", "coffee", "neighbourhood"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .paved, maxGradePercent: 3.0, notes: "Flat, paved sidewalks throughout Ohio City."),
                shotPins: [
                    ShotPin(id: UUID(), title: "West Side Market Clock Tower", shootingNotes: "The terracotta Romanesque clock tower is stunning. Shoot from W 25th St at mid-morning when the light hits the facade. Inside: wide lens for the iron arcade.", coordinate: RouteCoordinate(latitude: 41.4851, longitude: -81.7031, elevationFt: 620), bestTimeOfDay: .goldenHourMorning, suggestedFocalLength: "24–35mm", tags: [.architecture]),
                ],
                historicalPoints: [
                    HistoricalPoint(id: UUID(), title: "West Side Market — 1912", era: "1912", description: "Opened in 1912, this is one of the oldest continuously operating markets in the US. The vaulted arcade was engineered by the same firm behind the Cleveland Terminal Tower.", coordinate: RouteCoordinate(latitude: 41.4851, longitude: -81.7031, elevationFt: 620)),
                ],
                darkSafety: DarkSafetyRating(overallScore: 4, lightingQuality: 4, footTraffic: 4, communityNotes: "Very active neighbourhood. Busy restaurants and bars until late.", recommendedAfterDark: true)
            ),
            HikeRoute(
                id: UUID(),
                name: "University Circle Cultural Loop",
                description: "Circle one of the densest concentrations of museums and cultural institutions in the US — the Cleveland Museum of Art (free), Natural History Museum, Botanical Garden, and Wade Oval, all walkable from each other.",
                neighborhood: "University Circle",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike],
                coordinates: [
                    RouteCoordinate(latitude: 41.5097, longitude: -81.6082, elevationFt: 780),
                    RouteCoordinate(latitude: 41.5080, longitude: -81.6050, elevationFt: 779),
                    RouteCoordinate(latitude: 41.5060, longitude: -81.6030, elevationFt: 778),
                    RouteCoordinate(latitude: 41.5070, longitude: -81.6065, elevationFt: 780),
                    RouteCoordinate(latitude: 41.5097, longitude: -81.6082, elevationFt: 780),
                ],
                distanceMiles: 2.5,
                elevationGainFt: 42,
                estimatedMinutes: 52,
                rating: 4.6,
                reviewCount: 267,
                isEditorsPick: false,
                tags: ["museums", "culture", "free", "park"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .paved, maxGradePercent: 3.0, notes: "Well-maintained paved paths. CMA and Natural History Museum fully accessible."),
                shotPins: [],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(overallScore: 3, lightingQuality: 3, footTraffic: 2, communityNotes: "Quieter at night — daytime and evening cultural events bring foot traffic. Wade Oval well lit.", recommendedAfterDark: false)
            ),
        ],
        neighborhoods: [
            WalkableNeighborhood(name: "Ohio City", walkScore: 88, coordinates: [CLLocationCoordinate2D(latitude: 41.4920, longitude: -81.7110), CLLocationCoordinate2D(latitude: 41.4920, longitude: -81.6930), CLLocationCoordinate2D(latitude: 41.4780, longitude: -81.6930), CLLocationCoordinate2D(latitude: 41.4780, longitude: -81.7110)], highlights: ["West Side Market", "W 25th St restaurants", "Great Lakes Brewing"], notes: "Cleveland's most walkable neighbourhood. Dense, flat, lined with independent businesses and Victorian homes."),
            WalkableNeighborhood(name: "Tremont", walkScore: 82, coordinates: [CLLocationCoordinate2D(latitude: 41.4800, longitude: -81.6970), CLLocationCoordinate2D(latitude: 41.4800, longitude: -81.6820), CLLocationCoordinate2D(latitude: 41.4680, longitude: -81.6820), CLLocationCoordinate2D(latitude: 41.4680, longitude: -81.6970)], highlights: ["Lincoln Park", "gallery scene", "Tremont Tap House", "arts district"], notes: "Bohemian arts district on a bluff above the Flats. Walkable restaurant strip with city views."),
            WalkableNeighborhood(name: "University Circle", walkScore: 78, coordinates: [CLLocationCoordinate2D(latitude: 41.5160, longitude: -81.6200), CLLocationCoordinate2D(latitude: 41.5160, longitude: -81.5980), CLLocationCoordinate2D(latitude: 41.5020, longitude: -81.5980), CLLocationCoordinate2D(latitude: 41.5020, longitude: -81.6200)], highlights: ["CMA (free)", "Natural History Museum", "Wade Oval", "Botanical Garden"], notes: "Dense cultural campus — some of the best free museums in the country, all walkable from each other."),
            WalkableNeighborhood(name: "The Flats", walkScore: 75, coordinates: [CLLocationCoordinate2D(latitude: 41.5020, longitude: -81.7050), CLLocationCoordinate2D(latitude: 41.5020, longitude: -81.6870), CLLocationCoordinate2D(latitude: 41.4870, longitude: -81.6870), CLLocationCoordinate2D(latitude: 41.4870, longitude: -81.7050)], highlights: ["Cuyahoga River", "Towpath Trail", "lift bridges", "brewery row"], notes: "Historic industrial waterfront being revived. Great for evening walks along the river."),
        ]
    )

    // MARK: - Windsor, ON

    static let windsor = FeaturedCity(
        id: "windsor",
        name: "Windsor",
        state: "ON",
        emoji: "🌉",
        tagline: "Detroit's twin city across the river",
        center: CLLocationCoordinate2D(latitude: 42.3149, longitude: -83.0364),
        routes: [
            HikeRoute(
                id: UUID(),
                name: "Windsor Riverfront Trail",
                description: "Walk the most striking urban waterfront in Canada — the Windsor Riverfront faces the Detroit skyline across the Detroit River. The Odette Sculpture Park lines the path with 31 monumental sculptures.",
                neighborhood: "Downtown Windsor",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike, .scooter],
                coordinates: [
                    RouteCoordinate(latitude: 42.3103, longitude: -83.0490, elevationFt: 575),
                    RouteCoordinate(latitude: 42.3097, longitude: -83.0420, elevationFt: 575),
                    RouteCoordinate(latitude: 42.3095, longitude: -83.0370, elevationFt: 575),
                    RouteCoordinate(latitude: 42.3092, longitude: -83.0300, elevationFt: 575),
                    RouteCoordinate(latitude: 42.3095, longitude: -83.0250, elevationFt: 575),
                ],
                distanceMiles: 2.2,
                elevationGainFt: 5,
                estimatedMinutes: 44,
                rating: 4.8,
                reviewCount: 523,
                isEditorsPick: true,
                tags: ["waterfront", "sculpture", "skyline", "flat"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .paved, maxGradePercent: 1.0, notes: "Completely flat paved trail. One of the most accessible waterfront walks in Ontario."),
                shotPins: [
                    ShotPin(id: UUID(), title: "Detroit Skyline from Windsor", shootingNotes: "The only place in Canada where you look south into the US. Frame the Renaissance Center across the water. Golden hour from the west lights up the Detroit towers brilliantly.", coordinate: RouteCoordinate(latitude: 42.3095, longitude: -83.0370, elevationFt: 575), bestTimeOfDay: .goldenHourEvening, suggestedFocalLength: "50–200mm", tags: [.architecture, .water]),
                ],
                historicalPoints: [
                    HistoricalPoint(id: UUID(), title: "Underground Railroad — Freedom's Crossing", era: "1830s–1860s", description: "Windsor was the final stop on the Underground Railroad. Thousands of freedom-seekers crossed the Detroit River here to reach Canada and freedom. A monument near Dieppe Park marks the crossing point.", coordinate: RouteCoordinate(latitude: 42.3092, longitude: -83.0300, elevationFt: 575)),
                ],
                darkSafety: DarkSafetyRating(overallScore: 5, lightingQuality: 5, footTraffic: 4, communityNotes: "Exceptionally well lit and heavily used. Safe at all hours.", recommendedAfterDark: true)
            ),
            HikeRoute(
                id: UUID(),
                name: "Walkerville Heritage Walk",
                description: "Walkerville is one of the best-preserved early 20th-century company-town neighbourhoods in Canada — built by the Hiram Walker whisky family. Grand Edwardian homes, brick streets, and Willistead Manor make this a hidden gem.",
                neighborhood: "Walkerville",
                difficulty: .easy,
                supportedModes: [.walk, .run],
                coordinates: [
                    RouteCoordinate(latitude: 42.3234, longitude: -83.0177, elevationFt: 592),
                    RouteCoordinate(latitude: 42.3220, longitude: -83.0160, elevationFt: 591),
                    RouteCoordinate(latitude: 42.3200, longitude: -83.0150, elevationFt: 590),
                    RouteCoordinate(latitude: 42.3185, longitude: -83.0165, elevationFt: 591),
                    RouteCoordinate(latitude: 42.3200, longitude: -83.0190, elevationFt: 592),
                    RouteCoordinate(latitude: 42.3234, longitude: -83.0177, elevationFt: 592),
                ],
                distanceMiles: 1.5,
                elevationGainFt: 20,
                estimatedMinutes: 32,
                rating: 4.6,
                reviewCount: 187,
                isEditorsPick: true,
                tags: ["heritage", "Edwardian", "whisky", "mansion"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .paved, maxGradePercent: 2.0, notes: "Flat paved neighbourhood streets."),
                shotPins: [
                    ShotPin(id: UUID(), title: "Willistead Manor", shootingNotes: "A 36-room Edwardian Tudor-Jacobean mansion set in public parkland. Shoot the facade from the south lawn. Overcast days give the stone a dramatic moody look.", coordinate: RouteCoordinate(latitude: 42.3200, longitude: -83.0150, elevationFt: 590), bestTimeOfDay: .anytime, suggestedFocalLength: "24–50mm", tags: [.architecture]),
                ],
                historicalPoints: [
                    HistoricalPoint(id: UUID(), title: "Hiram Walker & Sons Distillery — 1858", era: "1858", description: "American businessman Hiram Walker built a distillery here in 1858 — and then built an entire town around it. Canadian Club whisky is still made here, making it one of North America's oldest operating distilleries.", coordinate: RouteCoordinate(latitude: 42.3234, longitude: -83.0177, elevationFt: 592)),
                ],
                darkSafety: DarkSafetyRating(overallScore: 4, lightingQuality: 4, footTraffic: 2, communityNotes: "Quiet residential neighbourhood. Well-lit streets but low foot traffic at night.", recommendedAfterDark: false)
            ),
            HikeRoute(
                id: UUID(),
                name: "Downtown Windsor & Dieppe Park",
                description: "Walk Ouellette Ave — Windsor's main street — through downtown shops and restaurants, finishing at Dieppe Park on the waterfront for direct views of the Ambassador Bridge and Detroit skyline.",
                neighborhood: "Downtown Windsor",
                difficulty: .easy,
                supportedModes: [.walk, .run, .scooter],
                coordinates: [
                    RouteCoordinate(latitude: 42.3149, longitude: -83.0364, elevationFt: 580),
                    RouteCoordinate(latitude: 42.3140, longitude: -83.0340, elevationFt: 579),
                    RouteCoordinate(latitude: 42.3132, longitude: -83.0330, elevationFt: 578),
                    RouteCoordinate(latitude: 42.3105, longitude: -83.0350, elevationFt: 576),
                    RouteCoordinate(latitude: 42.3095, longitude: -83.0370, elevationFt: 575),
                ],
                distanceMiles: 1.3,
                elevationGainFt: 12,
                estimatedMinutes: 27,
                rating: 4.4,
                reviewCount: 234,
                isEditorsPick: false,
                tags: ["downtown", "waterfront", "bridge views", "shopping"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .paved, maxGradePercent: 1.5, notes: "Flat paved streets and waterfront."),
                shotPins: [],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(overallScore: 4, lightingQuality: 4, footTraffic: 3, communityNotes: "Active downtown strip. Waterfront well lit. Recommend staying on main streets.", recommendedAfterDark: true)
            ),
        ],
        neighborhoods: [
            WalkableNeighborhood(name: "Downtown Windsor", walkScore: 80, coordinates: [CLLocationCoordinate2D(latitude: 42.3220, longitude: -83.0480), CLLocationCoordinate2D(latitude: 42.3220, longitude: -83.0250), CLLocationCoordinate2D(latitude: 42.3070, longitude: -83.0250), CLLocationCoordinate2D(latitude: 42.3070, longitude: -83.0480)], highlights: ["Ouellette Ave", "Riverfront Trail", "Caesars Windsor", "Art Gallery of Windsor"], notes: "Compact, flat, and very walkable. The riverfront is the crown jewel — best Detroit skyline views anywhere."),
            WalkableNeighborhood(name: "Walkerville", walkScore: 72, coordinates: [CLLocationCoordinate2D(latitude: 42.3300, longitude: -83.0230), CLLocationCoordinate2D(latitude: 42.3300, longitude: -83.0070), CLLocationCoordinate2D(latitude: 42.3140, longitude: -83.0070), CLLocationCoordinate2D(latitude: 42.3140, longitude: -83.0230)], highlights: ["Willistead Manor", "Canadian Club Heritage Centre", "Devonshire Mall area", "Edwardian streetscapes"], notes: "Historic whisky-family company town. Beautifully preserved, quiet, and photogenic."),
            WalkableNeighborhood(name: "Riverside Drive East", walkScore: 68, coordinates: [CLLocationCoordinate2D(latitude: 42.3280, longitude: -82.9950), CLLocationCoordinate2D(latitude: 42.3280, longitude: -82.9720), CLLocationCoordinate2D(latitude: 42.3120, longitude: -82.9720), CLLocationCoordinate2D(latitude: 42.3120, longitude: -82.9950)], highlights: ["Riverside Drive waterfront", "Coventry Gardens", "Peace Fountain"], notes: "Quieter residential waterfront east of downtown. Coventry Gardens has great river views."),
            WalkableNeighborhood(name: "Sandwich Town", walkScore: 65, coordinates: [CLLocationCoordinate2D(latitude: 42.3250, longitude: -83.0750), CLLocationCoordinate2D(latitude: 42.3250, longitude: -83.0570), CLLocationCoordinate2D(latitude: 42.3090, longitude: -83.0570), CLLocationCoordinate2D(latitude: 42.3090, longitude: -83.0750)], highlights: ["Mackenzie Hall", "Baby House museum", "Sandwich Heritage Walk", "Ambassador Bridge views"], notes: "Windsor's oldest neighbourhood and a National Historic Site. Under-visited — worth exploring."),
        ]
    )

    // MARK: - London, Ontario

    static let londonON = FeaturedCity(
        id: "london_on",
        name: "London",
        state: "ON",
        emoji: "🎓",
        tagline: "Thames River trails & university energy",
        center: CLLocationCoordinate2D(latitude: 42.9849, longitude: -81.2453),
        routes: [
            HikeRoute(
                id: UUID(),
                name: "Forks of the Thames",
                description: "Walk the confluence of the north and south branches of the Thames River through London's historic core. Paved trails, pedestrian bridges, and views of the downtown skyline make this the city's signature walk.",
                neighborhood: "Downtown London",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike, .scooter],
                coordinates: [
                    RouteCoordinate(latitude: 42.9788, longitude: -81.2482, elevationFt: 866),
                    RouteCoordinate(latitude: 42.9800, longitude: -81.2440, elevationFt: 865),
                    RouteCoordinate(latitude: 42.9820, longitude: -81.2400, elevationFt: 864),
                    RouteCoordinate(latitude: 42.9810, longitude: -81.2450, elevationFt: 865),
                    RouteCoordinate(latitude: 42.9788, longitude: -81.2482, elevationFt: 866),
                ],
                distanceMiles: 2.0,
                elevationGainFt: 18,
                estimatedMinutes: 40,
                rating: 4.5,
                reviewCount: 298,
                isEditorsPick: true,
                tags: ["river", "flat", "paved", "bridges"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .paved, maxGradePercent: 1.5, notes: "Fully paved, very flat riverside trail."),
                shotPins: [
                    ShotPin(id: UUID(), title: "Confluence of the Thames", shootingNotes: "Stand at the forks where the two branches meet. Shoot downstream at golden hour when the light catches the water surface. A wide lens works well to capture both banks.", coordinate: RouteCoordinate(latitude: 42.9788, longitude: -81.2482, elevationFt: 866), bestTimeOfDay: .goldenHourEvening, suggestedFocalLength: "16–35mm", tags: [.water, .nature]),
                ],
                historicalPoints: [
                    HistoricalPoint(id: UUID(), title: "Labatt Memorial Park — World's Oldest Baseball Diamond", era: "1877", description: "Just north of the Forks, Labatt Park has hosted baseball since 1877 — making it the oldest baseball grounds in continuous use in the world, according to the Guinness Book of Records.", coordinate: RouteCoordinate(latitude: 42.9800, longitude: -81.2440, elevationFt: 865)),
                ],
                darkSafety: DarkSafetyRating(overallScore: 4, lightingQuality: 4, footTraffic: 3, communityNotes: "Well lit along the main trail. Active during evenings. Stick to paved paths.", recommendedAfterDark: true)
            ),
            HikeRoute(
                id: UUID(),
                name: "Old East Village Heritage Loop",
                description: "Old East Village is London's oldest commercial strip — Hamilton Road, lined with independent shops, murals, and a genuine neighbourhood feel that has nothing to do with big-box retail.",
                neighborhood: "Old East Village",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike],
                coordinates: [
                    RouteCoordinate(latitude: 42.9855, longitude: -81.2200, elevationFt: 892),
                    RouteCoordinate(latitude: 42.9870, longitude: -81.2180, elevationFt: 893),
                    RouteCoordinate(latitude: 42.9890, longitude: -81.2155, elevationFt: 894),
                    RouteCoordinate(latitude: 42.9870, longitude: -81.2135, elevationFt: 893),
                    RouteCoordinate(latitude: 42.9855, longitude: -81.2200, elevationFt: 892),
                ],
                distanceMiles: 1.8,
                elevationGainFt: 28,
                estimatedMinutes: 38,
                rating: 4.3,
                reviewCount: 142,
                isEditorsPick: false,
                tags: ["heritage", "murals", "local shops", "community"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .paved, maxGradePercent: 2.0, notes: "Flat paved sidewalks throughout."),
                shotPins: [],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(overallScore: 3, lightingQuality: 3, footTraffic: 2, communityNotes: "Active during business hours. Quieter at night — stick to Hamilton Rd main strip.", recommendedAfterDark: false)
            ),
            HikeRoute(
                id: UUID(),
                name: "Wortley Village to Westminster Ponds",
                description: "Start in Wortley Village — London's beloved 'village within a city' — and walk south to Westminster Ponds, a provincial nature reserve with lily-covered kettlehole ponds amid the suburbs.",
                neighborhood: "Wortley Village",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike],
                coordinates: [
                    RouteCoordinate(latitude: 42.9617, longitude: -81.2500, elevationFt: 925),
                    RouteCoordinate(latitude: 42.9590, longitude: -81.2485, elevationFt: 924),
                    RouteCoordinate(latitude: 42.9560, longitude: -81.2470, elevationFt: 922),
                    RouteCoordinate(latitude: 42.9530, longitude: -81.2480, elevationFt: 920),
                    RouteCoordinate(latitude: 42.9617, longitude: -81.2500, elevationFt: 925),
                ],
                distanceMiles: 2.3,
                elevationGainFt: 38,
                estimatedMinutes: 48,
                rating: 4.6,
                reviewCount: 211,
                isEditorsPick: true,
                tags: ["village", "nature", "ponds", "quiet"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: false, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .mixed, maxGradePercent: 4.0, notes: "Paved through Wortley, some gravel near Westminster Ponds."),
                shotPins: [
                    ShotPin(id: UUID(), title: "Westminster Ponds — Water Lilies", shootingNotes: "The kettlehole ponds are covered in water lilies in summer. Shoot from the boardwalk at mid-morning for calm reflections. Dragonflies are plentiful in July.", coordinate: RouteCoordinate(latitude: 42.9530, longitude: -81.2480, elevationFt: 920), bestTimeOfDay: .goldenHourMorning, suggestedFocalLength: "50–200mm", tags: [.nature, .water]),
                ],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(overallScore: 3, lightingQuality: 3, footTraffic: 2, communityNotes: "Wortley Village busy until late. Westminster Ponds dark and isolated at night.", recommendedAfterDark: false)
            ),
        ],
        neighborhoods: [
            WalkableNeighborhood(name: "Downtown London", walkScore: 88, coordinates: [CLLocationCoordinate2D(latitude: 42.9970, longitude: -81.2590), CLLocationCoordinate2D(latitude: 42.9970, longitude: -81.2300), CLLocationCoordinate2D(latitude: 42.9770, longitude: -81.2300), CLLocationCoordinate2D(latitude: 42.9770, longitude: -81.2590)], highlights: ["Covent Garden Market", "Budweiser Gardens", "Forks of the Thames", "Dundas St"], notes: "London's compact downtown is surprisingly walkable. The Forks trail system connects most of it."),
            WalkableNeighborhood(name: "Old East Village", walkScore: 78, coordinates: [CLLocationCoordinate2D(latitude: 42.9940, longitude: -81.2270), CLLocationCoordinate2D(latitude: 42.9940, longitude: -81.2050), CLLocationCoordinate2D(latitude: 42.9770, longitude: -81.2050), CLLocationCoordinate2D(latitude: 42.9770, longitude: -81.2270)], highlights: ["Hamilton Rd shops", "street murals", "Aeolian Hall", "community gardens"], notes: "London's most authentic neighbourhood. Independent shops, murals, and a strong community identity."),
            WalkableNeighborhood(name: "Wortley Village", walkScore: 82, coordinates: [CLLocationCoordinate2D(latitude: 42.9680, longitude: -81.2580), CLLocationCoordinate2D(latitude: 42.9680, longitude: -81.2390), CLLocationCoordinate2D(latitude: 42.9530, longitude: -81.2390), CLLocationCoordinate2D(latitude: 42.9530, longitude: -81.2580)], highlights: ["Wortley Rd shops", "Wortley Village Pub", "Westminster Ponds nearby", "farmers market"], notes: "Consistently voted London's favourite neighbourhood. Tight-knit, walkable village feel within the city."),
            WalkableNeighborhood(name: "Old North / Woodfield", walkScore: 70, coordinates: [CLLocationCoordinate2D(latitude: 43.0100, longitude: -81.2700), CLLocationCoordinate2D(latitude: 43.0100, longitude: -81.2440), CLLocationCoordinate2D(latitude: 42.9900, longitude: -81.2440), CLLocationCoordinate2D(latitude: 42.9900, longitude: -81.2700)], highlights: ["Woodfield heritage homes", "Victoria Park", "Western Fair District"], notes: "Beautiful Victorian and Edwardian homes. Walkable to downtown and parks."),
        ]
    )

    // MARK: - Paris, Ontario

    static let parisON = FeaturedCity(
        id: "paris_on",
        name: "Paris",
        state: "ON",
        emoji: "🌹",
        tagline: "Cobblestone streets & the Grand River",
        center: CLLocationCoordinate2D(latitude: 43.1952, longitude: -80.3844),
        routes: [
            HikeRoute(
                id: UUID(),
                name: "Grand River Loop",
                description: "A peaceful loop following the Grand River through Paris's small-town core. Pass the Penman's Dam, cross the century-old pedestrian bridge, and return via the cobblestone hill that gives this route its character.",
                neighborhood: "Downtown Paris",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike],
                coordinates: [
                    RouteCoordinate(latitude: 43.1952, longitude: -80.3844, elevationFt: 774),
                    RouteCoordinate(latitude: 43.1940, longitude: -80.3820, elevationFt: 770),
                    RouteCoordinate(latitude: 43.1920, longitude: -80.3800, elevationFt: 768),
                    RouteCoordinate(latitude: 43.1910, longitude: -80.3830, elevationFt: 770),
                    RouteCoordinate(latitude: 43.1930, longitude: -80.3860, elevationFt: 773),
                    RouteCoordinate(latitude: 43.1952, longitude: -80.3844, elevationFt: 774),
                ],
                distanceMiles: 2.0,
                elevationGainFt: 30,
                estimatedMinutes: 42,
                rating: 4.7,
                reviewCount: 186,
                isEditorsPick: true,
                tags: ["river", "cobblestone", "dam", "small-town"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: false, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .mixed, maxGradePercent: 5.0, notes: "Cobblestone hill requires care. Riverside paths are packed gravel."),
                shotPins: [
                    ShotPin(id: UUID(), title: "Penman's Dam & Covered Bridge Area", shootingNotes: "The historic dam and weir create a picturesque cascade. Shoot at golden hour when the low light rakes across the water. Morning mist in spring is spectacular.", coordinate: RouteCoordinate(latitude: 43.1920, longitude: -80.3800, elevationFt: 768), bestTimeOfDay: .goldenHourMorning, suggestedFocalLength: "24–50mm", tags: [.water, .nature]),
                    ShotPin(id: UUID(), title: "Cobblestone Hill — Grand River St N", shootingNotes: "One of the last cobblestone streets in Ontario. Shoot looking downhill toward the river — the texture and slope make a beautiful composition. Best in rain when wet cobbles catch the light.", coordinate: RouteCoordinate(latitude: 43.1950, longitude: -80.3838, elevationFt: 773), bestTimeOfDay: .anytime, suggestedFocalLength: "35–50mm", tags: [.architecture, .streetArt]),
                ],
                historicalPoints: [
                    HistoricalPoint(id: UUID(), title: "Paris Founded — 1829", era: "1829", description: "Paris was named for the gypsum deposits found here — used to make plaster of Paris. The cobblestone buildings downtown were built from local Paris cobblestone, giving the town its distinctive look.", coordinate: RouteCoordinate(latitude: 43.1952, longitude: -80.3844, elevationFt: 774)),
                ],
                darkSafety: DarkSafetyRating(overallScore: 4, lightingQuality: 3, footTraffic: 2, communityNotes: "Very safe small town. Light foot traffic at night but low crime. Riverside paths are unlit.", recommendedAfterDark: false)
            ),
            HikeRoute(
                id: UUID(),
                name: "Downtown Paris Heritage Walk",
                description: "A short stroll through downtown Paris's remarkably intact 19th-century streetscape. Cobblestone buildings, independent shops, and the Grand River at the bottom of the hill — a rare pocket of small-town Ontario charm.",
                neighborhood: "Downtown Paris",
                difficulty: .easy,
                supportedModes: [.walk],
                coordinates: [
                    RouteCoordinate(latitude: 43.1952, longitude: -80.3844, elevationFt: 774),
                    RouteCoordinate(latitude: 43.1960, longitude: -80.3830, elevationFt: 776),
                    RouteCoordinate(latitude: 43.1968, longitude: -80.3820, elevationFt: 778),
                    RouteCoordinate(latitude: 43.1958, longitude: -80.3855, elevationFt: 775),
                    RouteCoordinate(latitude: 43.1945, longitude: -80.3865, elevationFt: 773),
                    RouteCoordinate(latitude: 43.1952, longitude: -80.3844, elevationFt: 774),
                ],
                distanceMiles: 1.2,
                elevationGainFt: 22,
                estimatedMinutes: 25,
                rating: 4.5,
                reviewCount: 98,
                isEditorsPick: false,
                tags: ["heritage", "cobblestone", "village", "short"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: false, isStrollerFriendly: false, isLowImpact: true, hasStairSections: 0, surfaceType: .mixed, maxGradePercent: 6.0, notes: "Cobblestone streets are uneven. Not suitable for wheelchairs or strollers on the hill."),
                shotPins: [],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(overallScore: 3, lightingQuality: 3, footTraffic: 1, communityNotes: "Very quiet at night. Safe but not much foot traffic after 9pm.", recommendedAfterDark: false)
            ),
        ],
        neighborhoods: [
            WalkableNeighborhood(name: "Downtown Paris", walkScore: 72, coordinates: [CLLocationCoordinate2D(latitude: 43.2010, longitude: -80.3920), CLLocationCoordinate2D(latitude: 43.2010, longitude: -80.3760), CLLocationCoordinate2D(latitude: 43.1880, longitude: -80.3760), CLLocationCoordinate2D(latitude: 43.1880, longitude: -80.3920)], highlights: ["Cobblestone Hill", "Grand River St", "Market Square", "independent shops"], notes: "Compact, charming, and very walkable. The cobblestone downtown is one of Ontario's best-preserved small-town streetscapes."),
            WalkableNeighborhood(name: "Grand River District", walkScore: 65, coordinates: [CLLocationCoordinate2D(latitude: 43.1960, longitude: -80.3980), CLLocationCoordinate2D(latitude: 43.1960, longitude: -80.3790), CLLocationCoordinate2D(latitude: 43.1870, longitude: -80.3790), CLLocationCoordinate2D(latitude: 43.1870, longitude: -80.3980)], highlights: ["Penman's Dam", "riverside trails", "Barker's Bush Conservation Area"], notes: "The river corridor running through and around Paris. Best for peaceful nature walks."),
            WalkableNeighborhood(name: "Cobblestone District", walkScore: 75, coordinates: [CLLocationCoordinate2D(latitude: 43.1990, longitude: -80.3870), CLLocationCoordinate2D(latitude: 43.1990, longitude: -80.3790), CLLocationCoordinate2D(latitude: 43.1920, longitude: -80.3790), CLLocationCoordinate2D(latitude: 43.1920, longitude: -80.3870)], highlights: ["Grand River St N cobblestones", "Paris Museum", "historic storefronts"], notes: "The historic core of Paris. Named for the naturally occurring cobblestones used in 19th-century construction."),
        ]
    )

    // MARK: - Toronto, ON

    static let toronto = FeaturedCity(
        id: "toronto",
        name: "Toronto",
        state: "ON",
        emoji: "🍁",
        tagline: "Distillery District, markets & the lake",
        center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
        routes: [
            HikeRoute(
                id: UUID(),
                name: "Distillery District & St. Lawrence Market",
                description: "Walk from the Distillery District — 44 heritage buildings of Victorian industrial architecture converted into galleries, restaurants, and boutiques — through the old town to St. Lawrence Market, one of the world's great food markets.",
                neighborhood: "Distillery District / Old Town",
                difficulty: .easy,
                supportedModes: [.walk, .run],
                coordinates: [
                    RouteCoordinate(latitude: 43.6503, longitude: -79.3590, elevationFt: 252),
                    RouteCoordinate(latitude: 43.6495, longitude: -79.3620, elevationFt: 251),
                    RouteCoordinate(latitude: 43.6490, longitude: -79.3660, elevationFt: 250),
                    RouteCoordinate(latitude: 43.6487, longitude: -79.3717, elevationFt: 249),
                    RouteCoordinate(latitude: 43.6475, longitude: -79.3730, elevationFt: 249),
                ],
                distanceMiles: 2.1,
                elevationGainFt: 22,
                estimatedMinutes: 44,
                rating: 4.8,
                reviewCount: 1640,
                isEditorsPick: true,
                tags: ["heritage", "market", "Victorian", "galleries"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .mixed, maxGradePercent: 2.0, notes: "Distillery has brick cobblestone — manageable. St. Lawrence Market fully accessible."),
                shotPins: [
                    ShotPin(id: UUID(), title: "Distillery District — Mill St Corridor", shootingNotes: "The brick canyon of restored Gooderham & Worts buildings is incredible. Shoot down Mill St with a wide lens. Christmas market in December transforms the space with fairy lights.", coordinate: RouteCoordinate(latitude: 43.6503, longitude: -79.3590, elevationFt: 252), bestTimeOfDay: .bluehour, suggestedFocalLength: "16–35mm", tags: [.architecture, .industrial]),
                ],
                historicalPoints: [
                    HistoricalPoint(id: UUID(), title: "Gooderham & Worts Distillery — 1832", era: "1832–1990", description: "Once the largest distillery in the British Empire, producing up to 2 million gallons of whisky annually. It operated for 150 years and is now the largest collection of Victorian industrial architecture in North America.", coordinate: RouteCoordinate(latitude: 43.6503, longitude: -79.3590, elevationFt: 252)),
                ],
                darkSafety: DarkSafetyRating(overallScore: 5, lightingQuality: 5, footTraffic: 5, communityNotes: "One of the most active pedestrian areas in Toronto at all hours. Extremely safe.", recommendedAfterDark: true)
            ),
            HikeRoute(
                id: UUID(),
                name: "Kensington Market & Chinatown",
                description: "Kensington Market is Toronto at its most eclectic — vintage shops, Caribbean bakeries, cheesemongers, and murals packed into a few walkable blocks. Connect through Chinatown on Spadina for dim sum and bubble tea.",
                neighborhood: "Kensington / Chinatown",
                difficulty: .easy,
                supportedModes: [.walk, .run],
                coordinates: [
                    RouteCoordinate(latitude: 43.6553, longitude: -79.4010, elevationFt: 290),
                    RouteCoordinate(latitude: 43.6540, longitude: -79.3990, elevationFt: 289),
                    RouteCoordinate(latitude: 43.6525, longitude: -79.3965, elevationFt: 288),
                    RouteCoordinate(latitude: 43.6530, longitude: -79.3990, elevationFt: 289),
                    RouteCoordinate(latitude: 43.6553, longitude: -79.4010, elevationFt: 290),
                ],
                distanceMiles: 1.6,
                elevationGainFt: 18,
                estimatedMinutes: 34,
                rating: 4.7,
                reviewCount: 892,
                isEditorsPick: true,
                tags: ["market", "murals", "eclectic", "food"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .paved, maxGradePercent: 2.0, notes: "Flat and fully paved. Very busy sidewalks on weekends."),
                shotPins: [
                    ShotPin(id: UUID(), title: "Augusta Ave Murals", shootingNotes: "Kensington's main drag is covered in murals and colourful storefronts. Shoot from the middle of the street (pedestrianised on weekends). Saturdays bring out vendors and musicians.", coordinate: RouteCoordinate(latitude: 43.6553, longitude: -79.4010, elevationFt: 290), bestTimeOfDay: .midday, suggestedFocalLength: "24–50mm", tags: [.streetArt, .portrait]),
                ],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(overallScore: 4, lightingQuality: 4, footTraffic: 4, communityNotes: "Very busy even at night. Active restaurant and bar scene throughout. Very safe.", recommendedAfterDark: true)
            ),
            HikeRoute(
                id: UUID(),
                name: "Harbourfront & HTO Park",
                description: "Toronto's lakefront walk from the foot of Bay St past the Harbourfront Centre to HTO Park and Sugar Beach — two urban beaches with white sand, pink umbrellas, and direct views of Toronto Island and Lake Ontario.",
                neighborhood: "Waterfront",
                difficulty: .easy,
                supportedModes: [.walk, .run, .bike, .scooter],
                coordinates: [
                    RouteCoordinate(latitude: 43.6411, longitude: -79.3806, elevationFt: 246),
                    RouteCoordinate(latitude: 43.6400, longitude: -79.3760, elevationFt: 246),
                    RouteCoordinate(latitude: 43.6388, longitude: -79.3720, elevationFt: 246),
                    RouteCoordinate(latitude: 43.6375, longitude: -79.3680, elevationFt: 246),
                    RouteCoordinate(latitude: 43.6365, longitude: -79.3640, elevationFt: 246),
                ],
                distanceMiles: 2.5,
                elevationGainFt: 8,
                estimatedMinutes: 50,
                rating: 4.6,
                reviewCount: 1120,
                isEditorsPick: false,
                tags: ["lakefront", "beach", "flat", "waterfront"],
                accessibility: AccessibilityInfo(isWheelchairFriendly: true, isStrollerFriendly: true, isLowImpact: true, hasStairSections: 0, surfaceType: .paved, maxGradePercent: 1.0, notes: "Completely flat paved waterfront path. Fully accessible throughout."),
                shotPins: [
                    ShotPin(id: UUID(), title: "CN Tower from HTO Park", shootingNotes: "Frame the CN Tower with the pink Muskoka chairs and white sand in the foreground. A 35mm lens gets both the chairs and the tower. Blue hour is electric when the tower changes colour.", coordinate: RouteCoordinate(latitude: 43.6388, longitude: -79.3720, elevationFt: 246), bestTimeOfDay: .bluehour, suggestedFocalLength: "24–50mm", tags: [.architecture, .water]),
                ],
                historicalPoints: [],
                darkSafety: DarkSafetyRating(overallScore: 4, lightingQuality: 4, footTraffic: 3, communityNotes: "Harbourfront Centre active most evenings. Quieter east toward Sugar Beach at night.", recommendedAfterDark: true)
            ),
        ],
        neighborhoods: [
            WalkableNeighborhood(name: "Distillery District", walkScore: 96, coordinates: [CLLocationCoordinate2D(latitude: 43.6545, longitude: -79.3640), CLLocationCoordinate2D(latitude: 43.6545, longitude: -79.3520), CLLocationCoordinate2D(latitude: 43.6460, longitude: -79.3520), CLLocationCoordinate2D(latitude: 43.6460, longitude: -79.3640)], highlights: ["Gooderham & Worts heritage buildings", "Mill St galleries", "Christmas market", "CETO restaurant row"], notes: "44 restored Victorian industrial buildings — one of Toronto's most photogenic and walkable destinations."),
            WalkableNeighborhood(name: "Kensington Market", walkScore: 97, coordinates: [CLLocationCoordinate2D(latitude: 43.6600, longitude: -79.4080), CLLocationCoordinate2D(latitude: 43.6600, longitude: -79.3930), CLLocationCoordinate2D(latitude: 43.6490, longitude: -79.3930), CLLocationCoordinate2D(latitude: 43.6490, longitude: -79.4080)], highlights: ["Augusta Ave", "Baldwin St", "vintage shops", "international food vendors"], notes: "The most eclectic square kilometre in Canada. Car-free on weekends. Dense, flat, and full of character."),
            WalkableNeighborhood(name: "Queen West", walkScore: 95, coordinates: [CLLocationCoordinate2D(latitude: 43.6510, longitude: -79.4250), CLLocationCoordinate2D(latitude: 43.6510, longitude: -79.3920), CLLocationCoordinate2D(latitude: 43.6400, longitude: -79.3920), CLLocationCoordinate2D(latitude: 43.6400, longitude: -79.4250)], highlights: ["Queen St W galleries", "Trinity Bellwoods Park", "design studios", "late-night diners"], notes: "One of the coolest streets in North America (Vogue). Dense galleries, cafes, and independent fashion — all walkable."),
            WalkableNeighborhood(name: "Harbourfront", walkScore: 88, coordinates: [CLLocationCoordinate2D(latitude: 43.6460, longitude: -79.4000), CLLocationCoordinate2D(latitude: 43.6460, longitude: -79.3580), CLLocationCoordinate2D(latitude: 43.6340, longitude: -79.3580), CLLocationCoordinate2D(latitude: 43.6340, longitude: -79.4000)], highlights: ["HTO Park urban beach", "Harbourfront Centre", "Sugar Beach", "ferry to Toronto Island"], notes: "Toronto's lake edge. Flat, paved, and great for walking with CN Tower as your compass."),
        ]
    )
}

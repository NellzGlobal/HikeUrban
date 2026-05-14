import Foundation

extension HikeRoute {
    static let detroitSamples: [HikeRoute] = [

        // 1. Riverfront Walk
        HikeRoute(
            id: UUID(),
            name: "Detroit Riverfront Walk",
            description: "A scenic walk along the Detroit Riverwalk from Hart Plaza east to the Dequindre Cut connector. Flat, paved, and stunning views of Windsor across the water.",
            neighborhood: "Downtown / Rivertown",
            difficulty: .easy,
            supportedModes: [.walk, .run, .bike, .scooter],
            coordinates: [
                RouteCoordinate(latitude: 42.3291, longitude: -83.0487, elevationFt: 574),
                RouteCoordinate(latitude: 42.3290, longitude: -83.0450, elevationFt: 574),
                RouteCoordinate(latitude: 42.3291, longitude: -83.0400, elevationFt: 575),
                RouteCoordinate(latitude: 42.3295, longitude: -83.0350, elevationFt: 576),
                RouteCoordinate(latitude: 42.3300, longitude: -83.0300, elevationFt: 576),
            ],
            distanceMiles: 2.8,
            elevationGainFt: 18,
            estimatedMinutes: 55,
            rating: 4.8,
            reviewCount: 312,
            isEditorsPick: true,
            tags: ["water", "skyline", "flat", "paved"],
            accessibility: AccessibilityInfo(
                isWheelchairFriendly: true,
                isStrollerFriendly: true,
                isLowImpact: true,
                hasStairSections: 0,
                surfaceType: .paved,
                maxGradePercent: 1.5,
                notes: "Fully paved, zero stairs. Best accessible route in Detroit."
            ),
            shotPins: [
                ShotPin(
                    id: UUID(),
                    title: "Hart Plaza Golden Hour",
                    shootingNotes: "Face east at sunset — Ren Cen reflects in the river. Get low for the water reflections.",
                    coordinate: RouteCoordinate(latitude: 42.3291, longitude: -83.0455, elevationFt: 574),
                    bestTimeOfDay: .goldenHourEvening,
                    suggestedFocalLength: "24–35mm",
                    tags: [.architecture, .water]
                ),
                ShotPin(
                    id: UUID(),
                    title: "Windsor Skyline Mirror",
                    shootingNotes: "Still mornings make the river glass-flat. Shoot the Windsor/Detroit skyline reflection.",
                    coordinate: RouteCoordinate(latitude: 42.3292, longitude: -83.0390, elevationFt: 574),
                    bestTimeOfDay: .goldenHourMorning,
                    suggestedFocalLength: "50–85mm",
                    tags: [.water, .architecture]
                ),
            ],
            historicalPoints: [
                HistoricalPoint(
                    id: UUID(),
                    title: "Joe Louis Arena Site",
                    era: "1979–2017",
                    description: "Home of the Red Wings for nearly 40 years. The arena was demolished in 2021 — you're standing where the ice used to be.",
                    coordinate: RouteCoordinate(latitude: 42.3290, longitude: -83.0485, elevationFt: 574)
                ),
            ],
            darkSafety: DarkSafetyRating(
                overallScore: 5,
                lightingQuality: 5,
                footTraffic: 4,
                communityNotes: "Very well lit. Active even late on weekends.",
                recommendedAfterDark: true
            )
        ),

        // 2. Midtown Art Walk
        HikeRoute(
            id: UUID(),
            name: "Midtown Art & Culture Loop",
            description: "Wind through Detroit's cultural corridor past the DIA, MOCAD, Wayne State campus, and the Fisher Building. Stops for street murals throughout.",
            neighborhood: "Midtown",
            difficulty: .easy,
            supportedModes: [.walk, .run, .bike],
            coordinates: [
                RouteCoordinate(latitude: 42.3596, longitude: -83.0636, elevationFt: 597),
                RouteCoordinate(latitude: 42.3584, longitude: -83.0650, elevationFt: 598),
                RouteCoordinate(latitude: 42.3564, longitude: -83.0641, elevationFt: 600),
                RouteCoordinate(latitude: 42.3554, longitude: -83.0612, elevationFt: 599),
                RouteCoordinate(latitude: 42.3566, longitude: -83.0590, elevationFt: 601),
                RouteCoordinate(latitude: 42.3596, longitude: -83.0636, elevationFt: 597),
            ],
            distanceMiles: 3.1,
            elevationGainFt: 42,
            estimatedMinutes: 65,
            rating: 4.6,
            reviewCount: 187,
            isEditorsPick: true,
            tags: ["murals", "culture", "architecture", "coffee"],
            accessibility: AccessibilityInfo(
                isWheelchairFriendly: true,
                isStrollerFriendly: true,
                isLowImpact: true,
                hasStairSections: 0,
                surfaceType: .paved,
                maxGradePercent: 3.0,
                notes: "All paved sidewalks. Some curb cuts are older — manageable but not perfect."
            ),
            shotPins: [
                ShotPin(
                    id: UUID(),
                    title: "DIA Facade",
                    shootingNotes: "The Beaux-Arts facade of the Detroit Institute of Arts is stunning at blue hour. Shoot from Woodward for the full frontage.",
                    coordinate: RouteCoordinate(latitude: 42.3596, longitude: -83.0636, elevationFt: 597),
                    bestTimeOfDay: .bluehour,
                    suggestedFocalLength: "24mm",
                    tags: [.architecture]
                ),
                ShotPin(
                    id: UUID(),
                    title: "Belt Alley Murals",
                    shootingNotes: "Detroit's most photogenic alley. Tight space — wide lens works best. Midday light bounces off walls nicely.",
                    coordinate: RouteCoordinate(latitude: 42.3316, longitude: -83.0477, elevationFt: 590),
                    bestTimeOfDay: .midday,
                    suggestedFocalLength: "16–24mm",
                    tags: [.streetArt, .portrait]
                ),
            ],
            historicalPoints: [
                HistoricalPoint(
                    id: UUID(),
                    title: "Motown Records – Original HQ",
                    era: "1959–1972",
                    description: "Hitsville U.S.A. — where Smokey Robinson, Diana Ross, and Marvin Gaye recorded. The original Studio A is preserved and open as a museum.",
                    coordinate: RouteCoordinate(latitude: 42.3626, longitude: -83.0747, elevationFt: 602)
                ),
            ],
            darkSafety: DarkSafetyRating(
                overallScore: 4,
                lightingQuality: 4,
                footTraffic: 3,
                communityNotes: "Well-lit main streets. Side blocks quieter at night. Stick to Woodward and Cass.",
                recommendedAfterDark: true
            )
        ),

        // 3. Eastern Market Loop
        HikeRoute(
            id: UUID(),
            name: "Eastern Market District Loop",
            description: "Start at Shed 5, explore the murals of the world's largest open-air market, push east through the Gratiot corridor and back through Belt Alley.",
            neighborhood: "Eastern Market",
            difficulty: .easy,
            supportedModes: [.walk, .run, .bike, .scooter],
            coordinates: [
                RouteCoordinate(latitude: 42.3503, longitude: -83.0387, elevationFt: 583),
                RouteCoordinate(latitude: 42.3510, longitude: -83.0360, elevationFt: 584),
                RouteCoordinate(latitude: 42.3522, longitude: -83.0340, elevationFt: 585),
                RouteCoordinate(latitude: 42.3530, longitude: -83.0370, elevationFt: 585),
                RouteCoordinate(latitude: 42.3515, longitude: -83.0400, elevationFt: 583),
                RouteCoordinate(latitude: 42.3503, longitude: -83.0387, elevationFt: 583),
            ],
            distanceMiles: 2.2,
            elevationGainFt: 28,
            estimatedMinutes: 45,
            rating: 4.7,
            reviewCount: 241,
            isEditorsPick: false,
            tags: ["murals", "food", "market", "flat"],
            accessibility: AccessibilityInfo(
                isWheelchairFriendly: true,
                isStrollerFriendly: true,
                isLowImpact: true,
                hasStairSections: 0,
                surfaceType: .paved,
                maxGradePercent: 2.0,
                notes: "Market area is all flat and paved. Best on Saturday mornings when market is active."
            ),
            shotPins: [
                ShotPin(
                    id: UUID(),
                    title: "Shed 5 Exterior Murals",
                    shootingNotes: "Eastern Market's giant mural shed walls. Morning light from the east hits perfectly. Go Saturday for market activity in the frame.",
                    coordinate: RouteCoordinate(latitude: 42.3503, longitude: -83.0387, elevationFt: 583),
                    bestTimeOfDay: .goldenHourMorning,
                    suggestedFocalLength: "24–50mm",
                    tags: [.streetArt, .portrait, .architecture]
                ),
            ],
            historicalPoints: [
                HistoricalPoint(
                    id: UUID(),
                    title: "Eastern Market — Since 1891",
                    era: "1891–Present",
                    description: "One of the oldest and largest historic public market districts in the US. At its peak, this was the food hub for all of southeast Michigan.",
                    coordinate: RouteCoordinate(latitude: 42.3503, longitude: -83.0387, elevationFt: 583)
                ),
            ],
            darkSafety: DarkSafetyRating(
                overallScore: 3,
                lightingQuality: 3,
                footTraffic: 2,
                communityNotes: "Quieter at night when market is closed. Recommended during daylight or market hours.",
                recommendedAfterDark: false
            )
        ),

        // 4. Corktown Heritage Trail
        HikeRoute(
            id: UUID(),
            name: "Corktown Heritage Trail",
            description: "Detroit's oldest neighborhood. Circle Michigan Central Station, walk through Roosevelt Park, and explore the streets where Ford's new campus is rising.",
            neighborhood: "Corktown",
            difficulty: .moderate,
            supportedModes: [.walk, .hike, .run],
            coordinates: [
                RouteCoordinate(latitude: 42.3314, longitude: -83.0746, elevationFt: 591),
                RouteCoordinate(latitude: 42.3330, longitude: -83.0770, elevationFt: 592),
                RouteCoordinate(latitude: 42.3350, longitude: -83.0750, elevationFt: 594),
                RouteCoordinate(latitude: 42.3340, longitude: -83.0720, elevationFt: 593),
                RouteCoordinate(latitude: 42.3314, longitude: -83.0746, elevationFt: 591),
            ],
            distanceMiles: 3.8,
            elevationGainFt: 67,
            estimatedMinutes: 80,
            rating: 4.5,
            reviewCount: 143,
            isEditorsPick: true,
            tags: ["heritage", "architecture", "industrial", "Ford"],
            accessibility: AccessibilityInfo(
                isWheelchairFriendly: false,
                isStrollerFriendly: true,
                isLowImpact: false,
                hasStairSections: 2,
                surfaceType: .mixed,
                maxGradePercent: 6.0,
                notes: "Two stair sections near the station approach. Some unpaved areas near the rail corridor."
            ),
            shotPins: [
                ShotPin(
                    id: UUID(),
                    title: "Michigan Central Station — Roosevelt Park",
                    shootingNotes: "Shoot the station from the park lawn with a wide lens. The Beaux-Arts facade is enormous. Golden hour turns the stone warm amber.",
                    coordinate: RouteCoordinate(latitude: 42.3314, longitude: -83.0746, elevationFt: 591),
                    bestTimeOfDay: .goldenHourEvening,
                    suggestedFocalLength: "24–35mm",
                    tags: [.architecture, .industrial]
                ),
                ShotPin(
                    id: UUID(),
                    title: "Station Interior Atrium",
                    shootingNotes: "Now Ford's HQ — the restored grand hall is open. Shoot the skylight from below. Midday for maximum natural light through the glass.",
                    coordinate: RouteCoordinate(latitude: 42.3318, longitude: -83.0748, elevationFt: 592),
                    bestTimeOfDay: .midday,
                    suggestedFocalLength: "16–24mm",
                    tags: [.architecture]
                ),
            ],
            historicalPoints: [
                HistoricalPoint(
                    id: UUID(),
                    title: "Michigan Central Station Opens",
                    era: "1913",
                    description: "Opened in 1913, this was once the tallest rail station in the world. It closed in 1988 and sat abandoned for 30 years before Ford acquired it in 2018.",
                    coordinate: RouteCoordinate(latitude: 42.3314, longitude: -83.0746, elevationFt: 591)
                ),
                HistoricalPoint(
                    id: UUID(),
                    title: "Corktown — Detroit's Oldest Neighbourhood",
                    era: "1840s",
                    description: "Founded by Irish immigrants from County Cork fleeing the famine. The neighbourhood's tight grid of brick workers' cottages has survived nearly two centuries.",
                    coordinate: RouteCoordinate(latitude: 42.3340, longitude: -83.0720, elevationFt: 593)
                ),
            ],
            darkSafety: DarkSafetyRating(
                overallScore: 3,
                lightingQuality: 3,
                footTraffic: 3,
                communityNotes: "Main Street Corktown is lively. Quieter near the station perimeter at night.",
                recommendedAfterDark: false
            )
        ),

        // 5. Dequindre Cut
        HikeRoute(
            id: UUID(),
            name: "Dequindre Cut Greenway",
            description: "A converted rail line running from the Riverfront north to Eastern Market — Detroit's version of the High Line. Lined with murals end to end.",
            neighborhood: "Lower East Side",
            difficulty: .easy,
            supportedModes: [.walk, .run, .bike, .scooter],
            coordinates: [
                RouteCoordinate(latitude: 42.3305, longitude: -83.0298, elevationFt: 578),
                RouteCoordinate(latitude: 42.3340, longitude: -83.0296, elevationFt: 579),
                RouteCoordinate(latitude: 42.3380, longitude: -83.0295, elevationFt: 581),
                RouteCoordinate(latitude: 42.3420, longitude: -83.0294, elevationFt: 582),
                RouteCoordinate(latitude: 42.3460, longitude: -83.0295, elevationFt: 583),
                RouteCoordinate(latitude: 42.3500, longitude: -83.0297, elevationFt: 583),
            ],
            distanceMiles: 1.4,
            elevationGainFt: 22,
            estimatedMinutes: 30,
            rating: 4.9,
            reviewCount: 408,
            isEditorsPick: true,
            tags: ["murals", "rail-trail", "flat", "greenway"],
            accessibility: AccessibilityInfo(
                isWheelchairFriendly: true,
                isStrollerFriendly: true,
                isLowImpact: true,
                hasStairSections: 0,
                surfaceType: .paved,
                maxGradePercent: 1.0,
                notes: "Ramp access at both ends. Perfectly flat. One of Detroit's best accessible greenways."
            ),
            shotPins: [
                ShotPin(
                    id: UUID(),
                    title: "The Cut — Looking North",
                    shootingNotes: "The sunken corridor creates a natural leading line. Shoot north from the southern entrance for a tunnel-of-murals effect.",
                    coordinate: RouteCoordinate(latitude: 42.3320, longitude: -83.0297, elevationFt: 578),
                    bestTimeOfDay: .midday,
                    suggestedFocalLength: "24–35mm",
                    tags: [.streetArt, .abstract]
                ),
            ],
            historicalPoints: [
                HistoricalPoint(
                    id: UUID(),
                    title: "Grand Trunk Western Railroad",
                    era: "1930s–1980s",
                    description: "This rail corridor moved freight from the docks to factories across the city. Abandoned in the 1980s, it lay dormant for 20 years before the city converted it to a greenway.",
                    coordinate: RouteCoordinate(latitude: 42.3400, longitude: -83.0295, elevationFt: 581)
                ),
            ],
            darkSafety: DarkSafetyRating(
                overallScore: 4,
                lightingQuality: 4,
                footTraffic: 3,
                communityNotes: "Well lit along most of the Cut. Active with cyclists and runners until late.",
                recommendedAfterDark: true
            )
        ),

        // 6. New Center
        HikeRoute(
            id: UUID(),
            name: "New Center to North End",
            description: "Start at the stunning Fisher Building, head north through the North End — one of Detroit's most architecturally rich residential areas — and loop back via the Boulevard.",
            neighborhood: "New Center",
            difficulty: .moderate,
            supportedModes: [.walk, .hike, .run, .bike],
            coordinates: [
                RouteCoordinate(latitude: 42.3744, longitude: -83.0820, elevationFt: 608),
                RouteCoordinate(latitude: 42.3770, longitude: -83.0800, elevationFt: 611),
                RouteCoordinate(latitude: 42.3800, longitude: -83.0810, elevationFt: 614),
                RouteCoordinate(latitude: 42.3790, longitude: -83.0840, elevationFt: 613),
                RouteCoordinate(latitude: 42.3760, longitude: -83.0850, elevationFt: 610),
                RouteCoordinate(latitude: 42.3744, longitude: -83.0820, elevationFt: 608),
            ],
            distanceMiles: 4.2,
            elevationGainFt: 88,
            estimatedMinutes: 90,
            rating: 4.4,
            reviewCount: 96,
            isEditorsPick: false,
            tags: ["architecture", "residential", "art deco", "historic"],
            accessibility: AccessibilityInfo(
                isWheelchairFriendly: false,
                isStrollerFriendly: true,
                isLowImpact: false,
                hasStairSections: 1,
                surfaceType: .paved,
                maxGradePercent: 5.5,
                notes: "Mostly flat but one stair section entering Fisher Building plaza. Some older sidewalks have uneven surfaces."
            ),
            shotPins: [
                ShotPin(
                    id: UUID(),
                    title: "Fisher Building Arcade",
                    shootingNotes: "Detroit's 'largest art object' — the gilded interior arcade is breathtaking. Shoot the ceiling vault with a wide lens. Best light mid-morning when sun comes through the south windows.",
                    coordinate: RouteCoordinate(latitude: 42.3744, longitude: -83.0820, elevationFt: 608),
                    bestTimeOfDay: .midday,
                    suggestedFocalLength: "16–24mm",
                    tags: [.architecture]
                ),
            ],
            historicalPoints: [
                HistoricalPoint(
                    id: UUID(),
                    title: "Fisher Building — Albert Kahn, 1928",
                    era: "1928",
                    description: "Designed by Albert Kahn for the Fisher brothers (of Fisher Body Company fame). Built at the height of Detroit's automotive prosperity — the gold-tiled arcade cost more than most skyscrapers of the era.",
                    coordinate: RouteCoordinate(latitude: 42.3744, longitude: -83.0820, elevationFt: 608)
                ),
            ],
            darkSafety: DarkSafetyRating(
                overallScore: 3,
                lightingQuality: 3,
                footTraffic: 2,
                communityNotes: "Grand Boulevard is well-lit. Residential side streets darker. Recommend daytime for this route.",
                recommendedAfterDark: false
            )
        ),
    ]
}

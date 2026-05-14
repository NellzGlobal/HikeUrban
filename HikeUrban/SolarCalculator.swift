import Foundation
import CoreLocation

// MARK: - Solar Calculator
// Computes sunrise, sunset, golden hour, and blue hour for any coordinate and date.
// Algorithm derived from NOAA Solar Calculator.

struct SolarCalculator {

    struct SolarTimes {
        let sunrise: Date
        let sunset: Date

        var morningGoldenStart: Date { sunrise }
        var morningGoldenEnd: Date   { sunrise.addingTimeInterval(60 * 60) }
        var eveningGoldenStart: Date { sunset.addingTimeInterval(-60 * 60) }
        var eveningGoldenEnd: Date   { sunset }
        var eveningBlueStart: Date   { sunset }
        var eveningBlueEnd: Date     { sunset.addingTimeInterval(30 * 60) }
        var morningBlueStart: Date   { sunrise.addingTimeInterval(-30 * 60) }
        var morningBlueEnd: Date     { sunrise }

        func timeString(_ date: Date, in timeZone: TimeZone = .current) -> String {
            let f = DateFormatter()
            f.timeStyle = .short
            f.timeZone = timeZone
            return f.string(from: date)
        }
    }

    static func solarTimes(
        for coordinate: CLLocationCoordinate2D,
        on date: Date = Date(),
        timeZone: TimeZone = .current
    ) -> SolarTimes? {
        let calendar = Calendar(identifier: .gregorian)
        var cal = calendar
        cal.timeZone = timeZone

        let comps = cal.dateComponents([.year, .month, .day], from: date)
        guard let year = comps.year, let month = comps.month, let day = comps.day else { return nil }

        let jd = julianDate(year: year, month: month, day: day)
        let n  = jd - 2451545.0

        let L   = fmod(280.46 + 0.9856474 * n, 360.0)
        let g   = fmod(357.528 + 0.9856003 * n, 360.0)
        let lam = L + 1.915 * sin(g.rad) + 0.020 * sin((2 * g).rad)
        let eps = 23.439 - 0.0000004 * n

        let sinDec = sin(eps.rad) * sin(lam.rad)
        let dec    = asin(sinDec).deg

        let cosH = (cos((90.833).rad) - sin(coordinate.latitude.rad) * sin(dec.rad)) /
                   (cos(coordinate.latitude.rad) * cos(dec.rad))

        guard cosH >= -1 && cosH <= 1 else { return nil } // polar day/night

        let H  = acos(cosH).deg
        let RA = atan2(cos(eps.rad) * sin(lam.rad), cos(lam.rad)).deg / 15.0

        let eqT  = L / 15.0 - RA
        let noon = 12.0 - eqT - coordinate.longitude / 15.0

        let sunriseUT = noon - H / 15.0
        let sunsetUT  = noon + H / 15.0

        let tzOffset = Double(timeZone.secondsFromGMT(for: date)) / 3600.0

        guard let sunriseDate = toDate(decimalHour: sunriseUT + tzOffset,
                                       year: year, month: month, day: day,
                                       timeZone: timeZone),
              let sunsetDate  = toDate(decimalHour: sunsetUT + tzOffset,
                                       year: year, month: month, day: day,
                                       timeZone: timeZone)
        else { return nil }

        return SolarTimes(sunrise: sunriseDate, sunset: sunsetDate)
    }

    // MARK: - Helpers

    private static func julianDate(year: Int, month: Int, day: Int) -> Double {
        var y = year, m = month
        if m <= 2 { y -= 1; m += 12 }
        let A = Int(Double(y) / 100)
        let B = 2 - A + Int(Double(A) / 4)
        return floor(365.25 * Double(y + 4716))
             + floor(30.6001 * Double(m + 1))
             + Double(day) + Double(B) - 1524.5
    }

    private static func toDate(decimalHour: Double,
                                year: Int, month: Int, day: Int,
                                timeZone: TimeZone) -> Date? {
        var h = decimalHour
        if h < 0 { h += 24 }
        if h >= 24 { h -= 24 }
        var comps         = DateComponents()
        comps.year        = year
        comps.month       = month
        comps.day         = day
        comps.hour        = Int(h)
        comps.minute      = Int((h - Double(Int(h))) * 60)
        comps.second      = 0
        comps.timeZone    = timeZone
        return Calendar(identifier: .gregorian).date(from: comps)
    }
}

private extension Double {
    var rad: Double { self * .pi / 180 }
    var deg: Double { self * 180 / .pi }
}

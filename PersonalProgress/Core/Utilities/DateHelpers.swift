import Foundation

extension Date {

    /// The ISO 8601 week number for this date.
    var isoWeekNumber: Int {
        Calendar.iso8601.component(.weekOfYear, from: self)
    }

    /// The calendar year for this date.
    var calendarYear: Int {
        Calendar.current.component(.year, from: self)
    }

    /// The Monday that starts the ISO week containing this date.
    var startOfISOWeek: Date {
        var cal = Calendar.iso8601
        cal.minimumDaysInFirstWeek = 4
        let components = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return cal.date(from: components) ?? self
    }

    /// The Sunday that ends the ISO week containing this date.
    var endOfISOWeek: Date {
        startOfISOWeek.addingTimeInterval(6 * 24 * 60 * 60)
    }

    /// Whether this date falls in the same ISO week as another date.
    func isInSameWeek(as other: Date) -> Bool {
        let cal = Calendar.iso8601
        return cal.isDate(self, equalTo: other, toGranularity: .weekOfYear)
    }

    /// Whether this date is today.
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// A short, readable week label. E.g. "Week of Apr 7"
    var weekLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "Week of \(formatter.string(from: startOfISOWeek))"
    }
}

extension Calendar {
    static let iso8601: Calendar = {
        var cal = Calendar(identifier: .iso8601)
        cal.locale = Locale(identifier: "en_US_POSIX")
        return cal
    }()
}

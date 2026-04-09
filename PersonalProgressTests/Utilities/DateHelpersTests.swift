import Testing
@testable import PersonalProgress

@Suite("DateHelpers Tests")
struct DateHelpersTests {
    @Test("ISO week number is consistent with known date")
    func isoWeekNumberKnownDate() {
        // 2026-01-05 is the first Monday of 2026, ISO week 2
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 5
        let date = Calendar.iso8601.date(from: components)!
        #expect(date.isoWeekNumber == 2)
    }

    @Test("Start of ISO week is Monday")
    func startOfISOWeekIsMonday() {
        var components = DateComponents()
        components.year = 2026
        components.month = 3
        components.day = 11 // Wednesday
        let wednesday = Calendar.iso8601.date(from: components)!
        let monday = wednesday.startOfISOWeek
        #expect(Calendar.iso8601.component(.weekday, from: monday) == 2) // 2 = Monday
    }

    @Test("isInSameWeek returns true for same week")
    func isInSameWeekTrue() {
        var components = DateComponents()
        components.year = 2026
        components.month = 3
        components.day = 9 // Monday
        let monday = Calendar.iso8601.date(from: components)!
        components.day = 15 // Sunday
        let sunday = Calendar.iso8601.date(from: components)!
        #expect(monday.isInSameWeek(as: sunday))
    }

    @Test("isInSameWeek returns false for different weeks")
    func isInSameWeekFalse() {
        var components = DateComponents()
        components.year = 2026
        components.month = 3
        components.day = 15 // Sunday (end of week)
        let sunday = Calendar.iso8601.date(from: components)!
        components.day = 16 // Monday (start of next week)
        let monday = Calendar.iso8601.date(from: components)!
        #expect(!sunday.isInSameWeek(as: monday))
    }

    @Test("calendarYear returns correct year")
    func calendarYearCorrect() {
        var components = DateComponents()
        components.year = 2026
        components.month = 6
        components.day = 15
        let date = Calendar.current.date(from: components)!
        #expect(date.calendarYear == 2026)
    }
}

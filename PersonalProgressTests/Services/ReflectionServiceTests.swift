import Foundation
import Testing
import SwiftData
@testable import PersonalProgress

@Suite("ReflectionService Tests")
struct ReflectionServiceTests {
    private var container: ModelContainer!
    private var context: ModelContext!
    private let service = ReflectionService()

    init() throws {
        let schema = Schema([WeeklyReflection.self, DomainWeeklyRating.self])
        let config = ModelConfiguration(
            "ReflectionTests",
            schema: schema,
            isStoredInMemoryOnly: true
        )
        container = try ModelContainer(for: schema, configurations: config)
        context = ModelContext(container)
    }

    @Test("Creates reflection for current week")
    func createsReflectionForCurrentWeek() throws {
        let reflection = try service.currentWeekReflection(in: context)
        let now = Date.now
        #expect(reflection.weekStartDate.isInSameWeek(as: now))
    }

    @Test("Returns existing reflection for the same week")
    func returnsExistingReflectionForSameWeek() throws {
        let first = try service.currentWeekReflection(in: context)
        let second = try service.currentWeekReflection(in: context)
        #expect(first.persistentModelID == second.persistentModelID)
    }

    @Test("New reflection is not locked")
    func newReflectionIsNotLocked() throws {
        let reflection = try service.currentWeekReflection(in: context)
        #expect(!reflection.isLocked)
    }

    @Test("Reflection locks after 48 hours")
    func reflectionLocksAfter48Hours() throws {
        let pastDate = Date.now.addingTimeInterval(-49 * 60 * 60)
        let reflection = try #require(try service.reflection(forWeekContaining: pastDate, in: context))
        #expect(reflection.isLocked)
    }
}

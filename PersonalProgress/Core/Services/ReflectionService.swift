import Foundation
import SwiftData

struct ReflectionService {

    /// Returns the weekly reflection for the ISO week containing the given date, if one exists.
    func reflection(forWeekContaining date: Date, in context: ModelContext) throws -> WeeklyReflection? {
        let weekStart = date.startOfISOWeek
        let descriptor = FetchDescriptor<WeeklyReflection>(
            predicate: #Predicate { $0.weekStartDate == weekStart }
        )
        return try context.fetch(descriptor).first
    }

    /// Creates a new weekly reflection for the ISO week containing the given date.
    func createReflection(forWeekContaining date: Date, in context: ModelContext) throws -> WeeklyReflection {
        let weekStart = date.startOfISOWeek
        let reflection = WeeklyReflection(
            weekStartDate: weekStart,
            year: date.calendarYear,
            weekNumber: date.isoWeekNumber
        )
        context.insert(reflection)
        try context.save()
        return reflection
    }

    /// Returns the reflection for the current week, creating one if it does not exist.
    func currentWeekReflection(in context: ModelContext) throws -> WeeklyReflection {
        if let existing = try reflection(forWeekContaining: .now, in: context) {
            return existing
        }
        return try createReflection(forWeekContaining: .now, in: context)
    }

    /// Locks all reflections that have passed their 48-hour lock window.
    func lockExpiredReflections(in context: ModelContext) throws {
        let now = Date.now
        let descriptor = FetchDescriptor<WeeklyReflection>(
            predicate: #Predicate { !$0.isLocked }
        )
        let unlocked = try context.fetch(descriptor)
        for reflection in unlocked where reflection.lockDate < now {
            reflection.isLocked = true
        }
        try context.save()
    }

    func allReflections(forYear year: Int, in context: ModelContext) throws -> [WeeklyReflection] {
        let descriptor = FetchDescriptor<WeeklyReflection>(
            predicate: #Predicate { $0.year == year },
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
}

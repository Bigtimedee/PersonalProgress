import Foundation
import SwiftData

/// A single daily focus item — one thing the user commits to for a specific day.
///
/// Daily focus is intentionally minimal. The goal is not a full task manager;
/// it is a single daily anchor that keeps the user connected to their annual intentions.
/// One item per day. Possibly two. Never ten.
@Model
final class DailyFocus {
    var weeklyReflection: WeeklyReflection?

    /// The specific date this focus item belongs to.
    var date: Date

    /// The focus text: what the user intends to do or be today.
    var text: String

    /// Whether the user marked this done.
    var isCompleted: Bool

    var completedAt: Date?
    var createdAt: Date

    /// Optional: link to a specific intention this focus item advances.
    @Relationship var intention: Intention?

    init(
        weeklyReflection: WeeklyReflection? = nil,
        date: Date,
        text: String,
        createdAt: Date = .now
    ) {
        self.weeklyReflection = weeklyReflection
        self.date = date
        self.text = text
        self.isCompleted = false
        self.createdAt = createdAt
    }
}

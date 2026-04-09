import Foundation
import SwiftData

// MARK: - WeekScore

/// A 1–5 self-assessment of how a domain went during the week.
/// Deliberately simple: this is a feel, not a metric.
enum WeekScore: Int, Codable, CaseIterable {
    case poor = 1
    case belowExpectations = 2
    case okay = 3
    case good = 4
    case excellent = 5

    var label: String {
        switch self {
        case .poor: return "Poor"
        case .belowExpectations: return "Below Expectations"
        case .okay: return "Okay"
        case .good: return "Good"
        case .excellent: return "Excellent"
        }
    }

    var symbol: String {
        switch self {
        case .poor: return "1"
        case .belowExpectations: return "2"
        case .okay: return "3"
        case .good: return "4"
        case .excellent: return "5"
        }
    }
}

// MARK: - WeeklyReflection

/// A weekly planning and reflection session.
///
/// The user typically completes this on Sunday evening (planning the week ahead)
/// or Monday morning (reviewing the week just passed). The app supports both
/// forward-looking planning and backward-looking reflection in the same session.
@Model
final class WeeklyReflection {
    /// The Monday of the ISO week this reflection belongs to.
    var weekStartDate: Date
    var year: Int
    var weekNumber: Int

    // MARK: - Backward look (reflecting on the week just passed)

    /// Free-form reflection: how did the week actually go?
    var weekReflectionText: String?

    /// What was the single most important thing that happened or was accomplished?
    var weekHighlight: String?

    /// What did not go well, and why?
    var weekLowlight: String?

    /// One concrete learning from the week.
    var weekLearning: String?

    // MARK: - Forward look (planning the week ahead)

    /// What are the 1–3 most important outcomes for the coming week?
    var weeklyPriorities: [String]

    /// Free-form space for the user's "weekly intention" — a tone or theme they want to set.
    var weeklyIntentionText: String?

    // MARK: - Domain ratings

    /// Per-domain self-assessment scores for the week just passed.
    @Relationship(deleteRule: .cascade, inverse: \DomainWeeklyRating.reflection)
    var domainRatings: [DomainWeeklyRating] = []

    // MARK: - Daily focus items within this week

    @Relationship(deleteRule: .cascade, inverse: \DailyFocus.weeklyReflection)
    var dailyFocusItems: [DailyFocus] = []

    // MARK: - Metadata

    var createdAt: Date
    var lastEditedAt: Date

    /// Reflections lock 48 hours after creation. Once locked, they cannot be edited.
    /// This preserves the honest record of how the user felt at the time.
    var isLocked: Bool

    var completedAt: Date?

    init(
        weekStartDate: Date,
        year: Int,
        weekNumber: Int,
        weeklyPriorities: [String] = [],
        createdAt: Date = .now
    ) {
        self.weekStartDate = weekStartDate
        self.year = year
        self.weekNumber = weekNumber
        self.weeklyPriorities = weeklyPriorities
        self.createdAt = createdAt
        self.lastEditedAt = createdAt
        self.isLocked = false
    }

    /// Whether this reflection has any content entered.
    var hasContent: Bool {
        weekReflectionText != nil ||
        weekHighlight != nil ||
        !weeklyPriorities.isEmpty ||
        weeklyIntentionText != nil
    }

    /// The date at which this reflection auto-locks (48h after creation).
    var lockDate: Date {
        createdAt.addingTimeInterval(48 * 60 * 60)
    }
}

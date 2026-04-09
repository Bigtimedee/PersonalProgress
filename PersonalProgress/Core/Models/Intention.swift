import Foundation
import SwiftData

// MARK: - IntentionType

/// The type of intention distinguishes how it should be tracked and evaluated.
///
/// - goal: A specific, measurable outcome with a target date. "Run a marathon by October."
/// - habit: A recurring behavior. Tracked by frequency consistency. "Exercise 4x per week."
/// - ritual: A meaningful practice, tracked by presence — not performance. "Sunday evening review."
/// - commitment: A one-time declaration or promise. "Attend every school performance."
/// - actionItem: A concrete task that needs to be done. "Read 'Deep Work' by end of Q1."
enum IntentionType: String, Codable, CaseIterable {
    case goal
    case habit
    case ritual
    case commitment
    case actionItem

    var displayName: String {
        switch self {
        case .goal: return "Goal"
        case .habit: return "Habit"
        case .ritual: return "Ritual"
        case .commitment: return "Commitment"
        case .actionItem: return "Action"
        }
    }

    var systemImage: String {
        switch self {
        case .goal: return "target"
        case .habit: return "arrow.trianglehead.2.clockwise"
        case .ritual: return "sparkles"
        case .commitment: return "lock.shield.fill"
        case .actionItem: return "checkmark.circle.fill"
        }
    }
}

// MARK: - IntentionFrequency

/// For habits and rituals: how often are they intended to occur?
enum IntentionFrequency: String, Codable, CaseIterable {
    case daily
    case weekdays
    case weekly
    case biweekly
    case monthly
    case quarterly

    var displayName: String {
        switch self {
        case .daily: return "Daily"
        case .weekdays: return "Weekdays"
        case .weekly: return "Weekly"
        case .biweekly: return "Every 2 weeks"
        case .monthly: return "Monthly"
        case .quarterly: return "Quarterly"
        }
    }

    /// Expected occurrences per year (approximate, for accountability scoring).
    var occurrencesPerYear: Int {
        switch self {
        case .daily: return 365
        case .weekdays: return 260
        case .weekly: return 52
        case .biweekly: return 26
        case .monthly: return 12
        case .quarterly: return 4
        }
    }
}

// MARK: - CompletionState

/// The completion state of an intention.
enum CompletionState: String, Codable {
    case notStarted
    case inProgress
    case completed
    case abandoned

    var displayName: String {
        switch self {
        case .notStarted: return "Not Started"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .abandoned: return "Abandoned"
        }
    }

    var isTerminal: Bool {
        self == .completed || self == .abandoned
    }
}

// MARK: - Intention

/// A single intention within a DomainPlan. The fundamental unit of committed action.
///
/// One model handles all five conceptual types (goal/habit/ritual/commitment/actionItem)
/// via the `type` field and optional type-specific properties. This avoids a proliferation
/// of model classes while preserving meaningful distinctions at the UI layer.
@Model
final class Intention {
    var domainPlan: DomainPlan?
    var type: IntentionType
    var title: String

    /// Optional elaboration. The "why" or extra context behind this intention.
    var note: String?

    var sortOrder: Int
    var isArchived: Bool
    var createdAt: Date
    var lastEditedAt: Date

    // MARK: - Goal-specific

    /// For goals: the date by which this should be accomplished.
    var targetDate: Date?

    /// For goals and action items: the current completion state.
    var completionState: CompletionState

    /// For action items: the date it was completed.
    var completedAt: Date?

    // MARK: - Habit & Ritual specific

    /// For habits and rituals: how often they are intended to occur.
    var frequency: IntentionFrequency?

    /// For habits: the specific target per frequency period.
    /// Example: frequency = .weekly, frequencyTarget = 4 means "4 times per week"
    var frequencyTarget: Int?

    // MARK: - Commitment specific

    /// For commitments: a specific promise or pledge in the user's own words.
    /// Example: "I will never miss a bedtime with my kids without a genuine reason."
    var commitmentPledge: String?

    init(
        domainPlan: DomainPlan? = nil,
        type: IntentionType,
        title: String,
        note: String? = nil,
        sortOrder: Int = 0,
        targetDate: Date? = nil,
        completionState: CompletionState = .notStarted,
        frequency: IntentionFrequency? = nil,
        frequencyTarget: Int? = nil,
        commitmentPledge: String? = nil,
        createdAt: Date = .now
    ) {
        self.domainPlan = domainPlan
        self.type = type
        self.title = title
        self.note = note
        self.sortOrder = sortOrder
        self.isArchived = false
        self.targetDate = targetDate
        self.completionState = completionState
        self.frequency = frequency
        self.frequencyTarget = frequencyTarget
        self.commitmentPledge = commitmentPledge
        self.createdAt = createdAt
        self.lastEditedAt = createdAt
    }
}

import Foundation
import SwiftData

// MARK: - Quarter

enum Quarter: Int, Codable, CaseIterable {
    case q1 = 1
    case q2 = 2
    case q3 = 3
    case q4 = 4

    var displayName: String {
        "Q\(rawValue)"
    }

    var months: String {
        switch self {
        case .q1: return "January – March"
        case .q2: return "April – June"
        case .q3: return "July – September"
        case .q4: return "October – December"
        }
    }

    var startMonth: Int {
        (rawValue - 1) * 3 + 1
    }

    var endMonth: Int {
        rawValue * 3
    }
}

// MARK: - QuarterlyReview

/// A deep review of the full quarter against the annual letter commitments.
///
/// Quarterly reviews are the most important recurring practice in the app.
/// They are meant to be slow, deliberate, and honest — not quick check-ins.
/// The user reads their annual letter, reviews each domain, and makes course corrections.
@Model
final class QuarterlyReview {
    var year: Int
    var quarter: Quarter

    // MARK: - Overall reflection

    /// Free-form: how did the quarter go overall?
    var overallReflectionText: String?

    /// What was the most important thing accomplished this quarter?
    var quarterHighlight: String?

    /// What was the most significant miss or gap?
    var quarterGap: String?

    /// What single adjustment would have the biggest impact on the next quarter?
    var keyAdjustment: String?

    /// Whether the user re-read their annual letter as part of this review.
    var letterWasReRead: Bool

    // MARK: - Domain reviews

    @Relationship(deleteRule: .cascade, inverse: \DomainQuarterlyReview.quarterlyReview)
    var domainReviews: [DomainQuarterlyReview] = []

    // MARK: - Metadata

    var createdAt: Date
    var lastEditedAt: Date
    var completedAt: Date?

    /// Quarterly reviews lock 30 days after completion.
    var isLocked: Bool

    init(
        year: Int,
        quarter: Quarter,
        letterWasReRead: Bool = false,
        createdAt: Date = .now
    ) {
        self.year = year
        self.quarter = quarter
        self.letterWasReRead = letterWasReRead
        self.createdAt = createdAt
        self.lastEditedAt = createdAt
        self.isLocked = false
    }

    /// Whether the review has been meaningfully started.
    var hasContent: Bool {
        overallReflectionText != nil || !domainReviews.isEmpty
    }

    var lockDate: Date? {
        guard let completedAt else { return nil }
        return completedAt.addingTimeInterval(30 * 24 * 60 * 60)
    }
}

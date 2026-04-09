import Foundation
import SwiftData

// MARK: - AccountabilityScore

/// A 1–5 honest self-assessment of how well the user lived their intentions
/// in a given domain during the quarter. This is accountability, not performance
/// — the score reflects integrity to commitments, not external outcomes.
enum AccountabilityScore: Int, Codable, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5

    var label: String {
        switch self {
        case .one: return "Far Below"
        case .two: return "Below"
        case .three: return "On Track"
        case .four: return "Above"
        case .five: return "Exceptional"
        }
    }

    var description: String {
        switch self {
        case .one: return "Significantly fell short of commitments"
        case .two: return "Did not live up to the standard set"
        case .three: return "Lived roughly as intended"
        case .four: return "Exceeded the standard in meaningful ways"
        case .five: return "Outstanding — this domain was a highlight"
        }
    }
}

// MARK: - DomainQuarterlyReview

/// The quarterly assessment for a single domain.
@Model
final class DomainQuarterlyReview {
    var quarterlyReview: QuarterlyReview?
    var domainName: String

    /// How well did the user honor their commitments in this domain this quarter?
    var accountabilityScore: AccountabilityScore?

    /// Narrative: what happened in this domain this quarter?
    var reflectionText: String?

    /// Specific intentions reviewed during this domain review.
    /// Stored as IDs because SwiftData doesn't support direct many-to-many here.
    var reviewedIntentionIDs: [PersistentIdentifier]

    /// What one thing will the user do differently in this domain next quarter?
    var courseCorrection: String?

    var createdAt: Date

    init(
        quarterlyReview: QuarterlyReview? = nil,
        domainName: String,
        reviewedIntentionIDs: [PersistentIdentifier] = [],
        createdAt: Date = .now
    ) {
        self.quarterlyReview = quarterlyReview
        self.domainName = domainName
        self.reviewedIntentionIDs = reviewedIntentionIDs
        self.createdAt = createdAt
    }
}

import Foundation
import SwiftData

/// A DomainPlan is the container for everything a person intends within a
/// specific domain for a specific year. It binds a Domain to an AnnualLetter year.
///
/// Think of it as the chapter in the annual letter that is dedicated to, say, "Work" or "Health."
/// It holds the identity statements, success definitions, and all intentions for that year.
@Model
final class DomainPlan {
    var year: Int
    var domain: Domain?

    /// Identity statement: "In my role as [domain], I am..."
    /// This is aspirational — who they intend to be, not a goal.
    /// Example: "As a husband, I am fully present, deeply engaged, and fiercely committed."
    var identityStatement: String

    /// A private note expanding on the identity statement.
    var identityNote: String?

    var createdAt: Date
    var lastEditedAt: Date

    /// All "I will know I succeeded if..." definitions for this domain and year.
    @Relationship(deleteRule: .cascade, inverse: \SuccessDefinition.domainPlan)
    var successDefinitions: [SuccessDefinition] = []

    /// All intentions (goals, habits, rituals, commitments, action items) for this domain and year.
    @Relationship(deleteRule: .cascade, inverse: \Intention.domainPlan)
    var intentions: [Intention] = []

    init(
        year: Int,
        domain: Domain? = nil,
        identityStatement: String = "",
        identityNote: String? = nil,
        createdAt: Date = .now
    ) {
        self.year = year
        self.domain = domain
        self.identityStatement = identityStatement
        self.identityNote = identityNote
        self.createdAt = createdAt
        self.lastEditedAt = createdAt
    }

    /// Intentions filtered by type.
    func intentions(ofType type: IntentionType) -> [Intention] {
        intentions.filter { $0.type == type }
    }

    /// Active (non-archived) intentions only.
    var activeIntentions: [Intention] {
        intentions.filter { !$0.isArchived }
    }
}

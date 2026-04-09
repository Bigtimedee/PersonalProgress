import Foundation
import SwiftData

/// A single domain's self-assessment score within a weekly reflection.
/// Captures both a numeric score and an optional note explaining the rating.
@Model
final class DomainWeeklyRating {
    var reflection: WeeklyReflection?
    var domainName: String
    var score: WeekScore
    var note: String?
    var createdAt: Date

    init(
        reflection: WeeklyReflection? = nil,
        domainName: String,
        score: WeekScore,
        note: String? = nil,
        createdAt: Date = .now
    ) {
        self.reflection = reflection
        self.domainName = domainName
        self.score = score
        self.note = note
        self.createdAt = createdAt
    }
}

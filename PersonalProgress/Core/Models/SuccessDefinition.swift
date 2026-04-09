import Foundation
import SwiftData

/// A single "I will know I succeeded if..." statement within a domain for a year.
///
/// These are the measurable or observable criteria the user commits to at the
/// start of the year. They are the bridge between identity ("who I am") and
/// outcomes ("what happened"). Not goals in the traditional sense — these are
/// the user's own definition of what success looks like, in their own words.
///
/// Example: "I will know I succeeded in Health if I exercise 4x per week for
/// 48 of 52 weeks and complete my annual physical."
@Model
final class SuccessDefinition {
    var domainPlan: DomainPlan?
    var text: String
    var sortOrder: Int
    var createdAt: Date

    /// At year-end review: did the user meet this definition?
    var wasAchieved: Bool?

    /// A note written at year-end about how this played out.
    var yearEndNote: String?

    init(
        domainPlan: DomainPlan? = nil,
        text: String,
        sortOrder: Int = 0,
        createdAt: Date = .now
    ) {
        self.domainPlan = domainPlan
        self.text = text
        self.sortOrder = sortOrder
        self.createdAt = createdAt
    }
}

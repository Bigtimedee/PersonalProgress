import Foundation
import SwiftData

/// The annual planning letter — the source of truth for the entire year.
/// The user writes this letter in January (or any time) to define who they
/// want to be, what they want to accomplish, and how they intend to live.
///
/// The raw text is preserved verbatim. Structured content is extracted
/// into Domain, DomainPlan, and Intention models. In v2, AI parsing
/// can populate these structures automatically from the raw text.
@Model
final class AnnualLetter {
    var year: Int
    var title: String

    /// The full, unedited text of the letter as written by the user.
    /// Never modified after the first save of the year. Treat as sacred.
    var rawText: String

    /// A short (1–3 sentence) distillation of the year's theme.
    /// Optional — some people write this, others don't.
    var themeStatement: String?

    /// The "one word" or short phrase the user chooses to anchor the year.
    /// Example: "Presence", "Build", "Discipline"
    var yearWord: String?

    var createdAt: Date
    var lastEditedAt: Date

    /// Whether the letter has been sealed for the year.
    /// A sealed letter cannot be edited — it is a time capsule.
    /// The user explicitly chooses to seal it. Not automatic.
    var isSealed: Bool

    init(
        year: Int,
        title: String = "",
        rawText: String = "",
        themeStatement: String? = nil,
        yearWord: String? = nil,
        createdAt: Date = .now,
        isSealed: Bool = false
    ) {
        self.year = year
        self.title = title
        self.rawText = rawText
        self.themeStatement = themeStatement
        self.yearWord = yearWord
        self.createdAt = createdAt
        self.lastEditedAt = createdAt
        self.isSealed = isSealed
    }

    /// Human-readable display title. Falls back to "My [year] Letter" if no title set.
    var displayTitle: String {
        title.isEmpty ? "My \(year) Letter" : title
    }
}

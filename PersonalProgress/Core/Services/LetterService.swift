import Foundation
import SwiftData

/// Manages creation and editing of the annual letter.
struct LetterService {

    func createLetter(
        year: Int,
        title: String = "",
        rawText: String = "",
        in context: ModelContext
    ) throws -> AnnualLetter {
        let letter = AnnualLetter(year: year, title: title, rawText: rawText)
        context.insert(letter)
        try context.save()
        return letter
    }

    func updateLetterText(
        _ letter: AnnualLetter,
        rawText: String,
        in context: ModelContext
    ) throws {
        guard !letter.isSealed else { return }
        letter.rawText = rawText
        letter.lastEditedAt = .now
        try context.save()
    }

    func sealLetter(_ letter: AnnualLetter, in context: ModelContext) throws {
        letter.isSealed = true
        try context.save()
    }

    func letter(forYear year: Int, in context: ModelContext) throws -> AnnualLetter? {
        let descriptor = FetchDescriptor<AnnualLetter>(
            predicate: #Predicate { $0.year == year }
        )
        return try context.fetch(descriptor).first
    }

    func allLetters(in context: ModelContext) throws -> [AnnualLetter] {
        let descriptor = FetchDescriptor<AnnualLetter>(
            sortBy: [SortDescriptor(\.year, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
}

// MARK: - Letter Parser Protocol

/// Abstraction seam for v2: AI-assisted import of the annual letter.
/// In v1, users enter content manually. In v2, this protocol can be
/// satisfied by an implementation that uses on-device ML to parse raw text.
protocol LetterParserProtocol {
    func parseIdentityStatements(from text: String, domainName: String) -> [String]
    func parseSuccessDefinitions(from text: String, domainName: String) -> [String]
    func parseIntentions(from text: String, domainName: String) -> [(type: IntentionType, title: String)]
    func parseThemeStatement(from text: String) -> String?
    func parseYearWord(from text: String) -> String?
}

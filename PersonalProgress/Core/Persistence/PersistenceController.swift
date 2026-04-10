@preconcurrency import SwiftData
import Foundation

/// Configures and owns the SwiftData ModelContainer for the app.
///
/// All model types must be registered in the schema here. Adding a new model
/// requires adding it to the `schema` array below — nothing else.
final class PersistenceController {

    nonisolated(unsafe) static let shared = PersistenceController()

    let container: ModelContainer

    // MARK: - Schema

    private static let schema = Schema([
        AnnualLetter.self,
        Domain.self,
        DomainPlan.self,
        SuccessDefinition.self,
        Intention.self,
        WeeklyReflection.self,
        DomainWeeklyRating.self,
        DailyFocus.self,
        QuarterlyReview.self,
        DomainQuarterlyReview.self,
    ])

    // MARK: - Init

    private init(inMemory: Bool = false) {
        let configuration = ModelConfiguration(
            schema: PersistenceController.schema,
            isStoredInMemoryOnly: inMemory,
            allowsSave: true
        )
        do {
            container = try ModelContainer(
                for: PersistenceController.schema,
                configurations: configuration
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    // MARK: - UI Testing

    /// In-memory container for UI tests — always starts empty so onboarding is always shown.
    nonisolated(unsafe) static let uitesting = PersistenceController(inMemory: true)

    // MARK: - Preview

    /// In-memory container pre-populated with seed data for SwiftUI previews.
    @MainActor
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        PreviewData.populate(in: controller.container.mainContext)
        return controller
    }()
}

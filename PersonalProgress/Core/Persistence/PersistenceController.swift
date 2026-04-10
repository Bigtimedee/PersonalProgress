@preconcurrency import SwiftData
import Foundation

/// Configures and owns the SwiftData ModelContainer for the app.
///
/// All model types must be registered in the schema here. Adding a new model
/// requires adding it to the `schema` array below — nothing else.
final class PersistenceController {

    nonisolated(unsafe) static let shared = PersistenceController(
        inMemory: ProcessInfo.processInfo.arguments.contains("--uitesting")
    )

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
        let configuration: ModelConfiguration
        if inMemory {
            print("Persistence mode: in-memory (UITesting)")
            configuration = ModelConfiguration(
                schema: PersistenceController.schema,
                url: URL(fileURLWithPath: "/dev/null"),
                isStoredInMemoryOnly: true,
                allowsSave: true
            )
        } else {
            print("Persistence mode: disk")
            let appSupport = FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .first!
            try? FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)
            configuration = ModelConfiguration(
                schema: PersistenceController.schema,
                url: appSupport.appendingPathComponent("PersonalProgress.store"),
                isStoredInMemoryOnly: false,
                allowsSave: true
            )
        }
        do {
            container = try ModelContainer(
                for: PersistenceController.schema,
                configurations: configuration
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    // MARK: - Preview

    /// In-memory container pre-populated with seed data for SwiftUI previews.
    @MainActor
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        PreviewData.populate(in: controller.container.mainContext)
        return controller
    }()
}

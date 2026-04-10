import SwiftUI
import SwiftData

@main
struct PersonalProgressApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private var persistence: PersistenceController {
        ProcessInfo.processInfo.arguments.contains("--uitesting")
            ? PersistenceController.uitesting
            : PersistenceController.shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(persistence.container)
    }
}

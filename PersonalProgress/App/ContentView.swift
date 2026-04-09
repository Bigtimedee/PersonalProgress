import SwiftUI
import SwiftData

/// Root view. Decides whether to show onboarding or the main tab bar.
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var letters: [AnnualLetter]

    /// Onboarding is complete once the user has at least one annual letter.
    private var isOnboardingComplete: Bool {
        !letters.isEmpty
    }

    var body: some View {
        if isOnboardingComplete {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PersistenceController.preview.container)
}

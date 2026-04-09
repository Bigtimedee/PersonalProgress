import SwiftUI
import SwiftData

struct LetterView: View {
    @Query(sort: \AnnualLetter.year, order: .reverse) private var letters: [AnnualLetter]

    var body: some View {
        NavigationStack {
            if let currentLetter = letters.first {
                LetterReadingView(letter: currentLetter)
            } else {
                ContentUnavailableView(
                    "No Letter Yet",
                    systemImage: "doc.text",
                    description: Text("Complete onboarding to write your annual letter.")
                )
                .navigationTitle("My Letter")
            }
        }
    }
}

// MARK: - LetterReadingView

struct LetterReadingView: View {
    let letter: AnnualLetter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                if let themeStatement = letter.themeStatement {
                    Text(themeStatement)
                        .font(.bodyMedium)
                        .foregroundStyle(.textSecondary)
                        .italic()
                        .padding(.horizontal, AppTheme.Spacing.md)
                }

                Text(letter.rawText)
                    .font(.letterBody)
                    .padding(.horizontal, AppTheme.Spacing.md)
            }
            .padding(.vertical, AppTheme.Spacing.lg)
        }
        .navigationTitle(letter.displayTitle)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    LetterView()
        .modelContainer(PersistenceController.preview.container)
}

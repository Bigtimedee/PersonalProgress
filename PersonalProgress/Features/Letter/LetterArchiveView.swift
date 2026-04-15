import SwiftUI
import SwiftData

struct LetterArchiveView: View {
    @Query(sort: \AnnualLetter.year, order: .reverse) private var letters: [AnnualLetter]

    var body: some View {
        List {
            ForEach(letters) { letter in
                NavigationLink(destination: LetterReadingView(letter: letter)) {
                    letterRow(letter)
                }
            }
        }
        .navigationTitle("Past Letters")
        .navigationBarTitleDisplayMode(.large)
    }

    private func letterRow(_ letter: AnnualLetter) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack {
                Text(letter.displayTitle)
                    .font(.bodyMedium)
                    .foregroundStyle(.textPrimary)
                Spacer()
                if letter.isSealed {
                    Image(systemName: "lock.fill")
                        .font(.captionSmall)
                        .foregroundStyle(.textTertiary)
                }
            }
            if let yearWord = letter.yearWord, !yearWord.isEmpty {
                Text(yearWord.uppercased())
                    .font(.captionSmall)
                    .foregroundStyle(Color.appAccent)
                    .tracking(1.5)
            }
            Text(String(letter.year))
                .font(.captionMedium)
                .foregroundStyle(.textSecondary)
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }
}

#Preview {
    NavigationStack {
        LetterArchiveView()
    }
    .modelContainer(PersistenceController.preview.container)
}

import SwiftUI
import SwiftData

struct ReflectionDetailView: View {
    let reflection: WeeklyReflection

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                weekHeaderCard
                if reflection.isLocked {
                    LockBanner()
                        .padding(.horizontal, AppTheme.Spacing.xl)
                }
                if let text = reflection.weekReflectionText, !text.isEmpty {
                    readOnlySection(title: "Look Back", content: text)
                }
                if let highlight = reflection.weekHighlight, !highlight.isEmpty {
                    readOnlySection(title: "Highlight", content: highlight)
                }
                if let lowlight = reflection.weekLowlight, !lowlight.isEmpty {
                    readOnlySection(title: "Lowlight", content: lowlight)
                }
                if let learning = reflection.weekLearning, !learning.isEmpty {
                    readOnlySection(title: "Learning", content: learning)
                }
                if !reflection.domainRatings.isEmpty {
                    domainRatingsSection
                }
                if !reflection.weeklyPriorities.filter({ !$0.isEmpty }).isEmpty {
                    prioritiesSection
                }
                if let intention = reflection.weeklyIntentionText, !intention.isEmpty {
                    readOnlySection(title: "Weekly Intention", content: intention)
                }
            }
            .padding(.vertical, AppTheme.Spacing.lg)
        }
        .background(Color.surfaceGrouped)
        .navigationTitle(reflection.weekStartDate.weekLabel)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Week Header

    private var weekHeaderCard: some View {
        AppCard {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Week \(reflection.weekNumber) · \(reflection.year)")
                        .font(.captionSmall)
                        .foregroundStyle(.textTertiary)
                    Text("Weekly Reflection")
                        .font(.headingMedium)
                }
                Spacer()
                if reflection.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.bodyMedium)
                        .foregroundStyle(.textTertiary)
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
    }

    // MARK: - Read-Only Text Section

    private func readOnlySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: title)
                .padding(.horizontal, AppTheme.Spacing.xl)
            AppCard {
                Text(content)
                    .font(.bodySmall)
                    .foregroundStyle(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Domain Ratings

    private var domainRatingsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Domain Ratings")
                .padding(.horizontal, AppTheme.Spacing.xl)
            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    let sorted = reflection.domainRatings.sorted { $0.domainName < $1.domainName }
                    ForEach(sorted) { rating in
                        if rating.persistentModelID != sorted.first?.persistentModelID {
                            Divider()
                        }
                        domainRatingRow(rating: rating)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    private func domainRatingRow(rating: DomainWeeklyRating) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(rating.domainName)
                .font(.bodyMedium)
            RatingPicker(score: rating.score, isDisabled: true) { _ in }
            if let note = rating.note, !note.isEmpty {
                Text(note)
                    .font(.captionMedium)
                    .foregroundStyle(.textSecondary)
            }
        }
    }

    // MARK: - Priorities

    private var prioritiesSection: some View {
        let filled = reflection.weeklyPriorities.filter { !$0.isEmpty }
        return VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Look Ahead")
                .padding(.horizontal, AppTheme.Spacing.xl)
            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    ForEach(filled.indices, id: \.self) { index in
                        if index > 0 { Divider() }
                        HStack(spacing: AppTheme.Spacing.sm) {
                            Text("\(index + 1)")
                                .font(.captionSmall.weight(.semibold))
                                .foregroundStyle(.textTertiary)
                                .frame(width: 18)
                            Text(filled[index])
                                .font(.bodySmall)
                        }
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }
}

#Preview {
    let container = PersistenceController.preview.container
    let context = container.mainContext
    let reflections = try? context.fetch(FetchDescriptor<WeeklyReflection>())
    let reflection = reflections?.first ?? WeeklyReflection(
        weekStartDate: .now.startOfISOWeek,
        year: 2026,
        weekNumber: 16
    )
    return NavigationStack {
        ReflectionDetailView(reflection: reflection)
    }
    .modelContainer(container)
}

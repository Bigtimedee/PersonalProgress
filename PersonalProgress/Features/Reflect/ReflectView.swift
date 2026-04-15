import SwiftUI
import SwiftData

struct ReflectView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Domain> { !$0.isArchived }, sort: \Domain.sortOrder)
    private var domains: [Domain]

    @State private var currentReflection: WeeklyReflection?

    private let reflectionService = ReflectionService()

    var body: some View {
        NavigationStack {
            Group {
                if let reflection = currentReflection {
                    WeeklyReflectionForm(reflection: reflection, domains: domains)
                } else {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.surfaceGrouped)
                }
            }
            .navigationTitle("Reflect")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: ReflectionHistoryView()) {
                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                    }
                }
            }
        }
        .task { await loadCurrentReflection() }
    }

    private func loadCurrentReflection() async {
        currentReflection = try? reflectionService.currentWeekReflection(in: modelContext)
    }
}

// MARK: - WeeklyReflectionForm

struct WeeklyReflectionForm: View {
    @Bindable var reflection: WeeklyReflection
    let domains: [Domain]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                weekHeaderCard
                if reflection.isLocked {
                    LockBanner()
                        .padding(.horizontal, AppTheme.Spacing.xl)
                }
                lookBackSection
                highlightSection
                lowlightSection
                learningSection
                if !domains.isEmpty {
                    domainRatingsSection
                }
                prioritiesSection
                intentionSection
            }
            .padding(.vertical, AppTheme.Spacing.lg)
        }
        .background(Color.surfaceGrouped)
    }

    // MARK: - Week Header

    private var weekHeaderCard: some View {
        AppCard {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(reflection.weekStartDate.weekLabel)
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

    // MARK: - Look Back

    private var lookBackSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Look Back")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    FormFieldLabel(title: "How did the week go?")
                    TextEditor(text: Binding(
                        get: { reflection.weekReflectionText ?? "" },
                        set: { reflection.weekReflectionText = $0.isEmpty ? nil : $0 }
                    ))
                    .frame(minHeight: 100)
                    .disabled(reflection.isLocked)
                    .font(.bodySmall)
                    .foregroundStyle(.textPrimary)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Highlight

    private var highlightSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Highlight")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    FormFieldLabel(title: "The most important thing this week")
                    TextField(
                        "What stood out most?",
                        text: Binding(
                            get: { reflection.weekHighlight ?? "" },
                            set: { reflection.weekHighlight = $0.isEmpty ? nil : $0 }
                        ),
                        axis: .vertical
                    )
                    .font(.bodySmall)
                    .disabled(reflection.isLocked)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Lowlight

    private var lowlightSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Lowlight")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    FormFieldLabel(title: "What didn't go well?")
                    TextField(
                        "What struggled or fell short?",
                        text: Binding(
                            get: { reflection.weekLowlight ?? "" },
                            set: { reflection.weekLowlight = $0.isEmpty ? nil : $0 }
                        ),
                        axis: .vertical
                    )
                    .font(.bodySmall)
                    .disabled(reflection.isLocked)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Learning

    private var learningSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Learning")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    FormFieldLabel(title: "One concrete learning")
                    TextField(
                        "What did you learn this week?",
                        text: Binding(
                            get: { reflection.weekLearning ?? "" },
                            set: { reflection.weekLearning = $0.isEmpty ? nil : $0 }
                        ),
                        axis: .vertical
                    )
                    .font(.bodySmall)
                    .disabled(reflection.isLocked)
                }
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
                    ForEach(domains) { domain in
                        if domain.persistentModelID != domains.first?.persistentModelID {
                            Divider()
                        }
                        domainRatingRow(domain: domain)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    private func domainRatingRow(domain: Domain) -> some View {
        let existingRating = reflection.domainRatings.first { $0.domainName == domain.name }
        return VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack(spacing: AppTheme.Spacing.sm) {
                DomainIconBadge(
                    iconName: DomainIcon(rawValue: domain.iconName)?.rawValue ?? "star.fill",
                    size: 28
                )
                Text(domain.name)
                    .font(.bodyMedium)
                Spacer()
            }
            RatingPicker(score: existingRating?.score, isDisabled: reflection.isLocked) { score in
                upsertRating(for: domain, score: score)
            }
            if let existing = existingRating {
                TextField(
                    "Add a note…",
                    text: Binding(
                        get: { existing.note ?? "" },
                        set: { existing.note = $0.isEmpty ? nil : $0 }
                    ),
                    axis: .vertical
                )
                .font(.captionMedium)
                .foregroundStyle(.textSecondary)
                .disabled(reflection.isLocked)
            }
        }
    }

    private func upsertRating(for domain: Domain, score: WeekScore) {
        if let existing = reflection.domainRatings.first(where: { $0.domainName == domain.name }) {
            existing.score = score
        } else {
            let r = DomainWeeklyRating(
                reflection: reflection,
                domainName: domain.name,
                score: score
            )
            modelContext.insert(r)
            reflection.domainRatings.append(r)
        }
    }

    // MARK: - Priorities

    private var prioritiesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Look Ahead")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    FormFieldLabel(title: "Top priorities for next week")

                    VStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(reflection.weeklyPriorities.indices, id: \.self) { index in
                            HStack(spacing: AppTheme.Spacing.sm) {
                                Text("\(index + 1)")
                                    .font(.captionSmall.weight(.semibold))
                                    .foregroundStyle(.textTertiary)
                                    .frame(width: 18)
                                TextField("Priority \(index + 1)", text: Binding(
                                    get: { reflection.weeklyPriorities[index] },
                                    set: { reflection.weeklyPriorities[index] = $0 }
                                ))
                                .font(.bodySmall)
                                .disabled(reflection.isLocked)
                            }
                            if index < reflection.weeklyPriorities.count - 1 {
                                Divider()
                            }
                        }
                    }

                    if !reflection.isLocked && reflection.weeklyPriorities.count < 3 {
                        Button {
                            reflection.weeklyPriorities.append("")
                        } label: {
                            Label("Add Priority", systemImage: "plus")
                                .font(.captionMedium)
                                .foregroundStyle(Color.appAccent)
                        }
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Intention

    private var intentionSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Weekly Intention")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    FormFieldLabel(title: "How do you want to show up?")
                    TextField(
                        "Set a tone or theme for the week…",
                        text: Binding(
                            get: { reflection.weeklyIntentionText ?? "" },
                            set: { reflection.weeklyIntentionText = $0.isEmpty ? nil : $0 }
                        ),
                        axis: .vertical
                    )
                    .font(.bodySmall)
                    .disabled(reflection.isLocked)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }
}

#Preview {
    ReflectView()
        .modelContainer(PersistenceController.preview.container)
}

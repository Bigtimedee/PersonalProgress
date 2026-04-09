import SwiftUI
import SwiftData

struct ReflectView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentReflection: WeeklyReflection?

    private let reflectionService = ReflectionService()

    var body: some View {
        NavigationStack {
            Group {
                if let reflection = currentReflection {
                    WeeklyReflectionForm(reflection: reflection)
                } else {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.surfaceGrouped)
                }
            }
            .navigationTitle("Reflect")
            .navigationBarTitleDisplayMode(.large)
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
                prioritiesSection
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
}

#Preview {
    ReflectView()
        .modelContainer(PersistenceController.preview.container)
}

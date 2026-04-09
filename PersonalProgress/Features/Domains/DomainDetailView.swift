import SwiftUI
import SwiftData

struct DomainDetailView: View {
    let domain: Domain
    let year: Int

    @Environment(\.modelContext) private var modelContext

    private var plan: DomainPlan? { domain.plan(forYear: year) }
    private var status: DomainStatus {
        AccountabilityService.shared.status(for: domain, year: year, context: modelContext)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                headerCard
                if let plan {
                    if !plan.identityStatement.isEmpty {
                        identityCard(plan: plan)
                    }
                    if !plan.successDefinitions.isEmpty {
                        successCard(plan: plan)
                    }
                    intentionsSections(plan: plan)
                } else {
                    EmptyStateView(
                        systemImage: "doc.badge.plus",
                        title: "No Plan for \(year)",
                        message: "Add intentions to this domain from your annual letter."
                    )
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }
            }
            .padding(.vertical, AppTheme.Spacing.lg)
        }
        .background(Color.surfaceGrouped)
        .navigationTitle(domain.name)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Header

    private var headerCard: some View {
        AppCard {
            HStack(spacing: AppTheme.Spacing.md) {
                DomainIconBadge(
                    iconName: DomainIcon(rawValue: domain.iconName)?.rawValue ?? "star.fill",
                    size: 52
                )
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(domain.name)
                        .font(.headingLarge)
                    StatusPill(style: status.statusPillStyle)
                }
                Spacer()
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
    }

    // MARK: - Identity

    private func identityCard(plan: DomainPlan) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Identity")
                .padding(.horizontal, AppTheme.Spacing.xl)
            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(plan.identityStatement)
                        .font(.bodyMedium)
                        .foregroundStyle(.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                    if let note = plan.identityNote, !note.isEmpty {
                        Text(note)
                            .font(.bodySmall)
                            .foregroundStyle(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Success Definitions

    private func successCard(plan: DomainPlan) -> some View {
        let sorted = plan.successDefinitions.sorted { $0.sortOrder < $1.sortOrder }
        return VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Success Looks Like")
                .padding(.horizontal, AppTheme.Spacing.xl)
            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    ForEach(sorted) { def in
                        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                            Image(systemName: "checkmark.circle")
                                .font(.bodySmall)
                                .foregroundStyle(Color.appAccent)
                                .padding(.top, 2)
                            Text(def.text)
                                .font(.bodySmall)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Intentions

    @ViewBuilder
    private func intentionsSections(plan: DomainPlan) -> some View {
        ForEach(IntentionType.allCases, id: \.self) { type in
            let items = plan.intentions(ofType: type)
                .filter { !$0.isArchived }
                .sorted { $0.sortOrder < $1.sortOrder }
            if !items.isEmpty {
                intentionSection(title: type.displayName, systemImage: type.systemImage, items: items)
            }
        }
    }

    private func intentionSection(title: String, systemImage: String, items: [Intention]) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: title, systemImage: systemImage)
                .padding(.horizontal, AppTheme.Spacing.xl)
            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    ForEach(items) { intention in
                        if intention.persistentModelID != items.first?.persistentModelID {
                            Divider()
                        }
                        IntentionRowView(intention: intention)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }
}

// MARK: - IntentionRowView

struct IntentionRowView: View {
    let intention: Intention

    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Image(systemName: statusIcon)
                .font(.bodyMedium)
                .foregroundStyle(statusColor)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(intention.title)
                    .font(.bodyMedium)
                    .strikethrough(intention.completionState == .completed)

                if let note = intention.note, !note.isEmpty {
                    Text(note)
                        .font(.captionMedium)
                        .foregroundStyle(.textSecondary)
                }

                HStack(spacing: AppTheme.Spacing.sm) {
                    if let frequency = intention.frequency {
                        Label(frequency.displayName, systemImage: "arrow.trianglehead.2.clockwise")
                            .font(.captionSmall)
                            .foregroundStyle(.textTertiary)
                    }
                    if let targetDate = intention.targetDate {
                        Label(targetDate.formatted(date: .abbreviated, time: .omitted),
                              systemImage: "calendar")
                            .font(.captionSmall)
                            .foregroundStyle(.textTertiary)
                    }
                }
            }
            Spacer(minLength: 0)
        }
    }

    private var statusIcon: String {
        switch intention.completionState {
        case .completed:  return "checkmark.circle.fill"
        case .abandoned:  return "xmark.circle.fill"
        case .inProgress: return intention.type.systemImage
        case .notStarted: return intention.type.systemImage
        }
    }

    private var statusColor: Color {
        switch intention.completionState {
        case .completed:  return .appAccent
        case .abandoned:  return .textTertiary
        default:          return .appAccent
        }
    }
}

#Preview {
    let container = PersistenceController.preview.container
    let context = container.mainContext
    let domains = try? context.fetch(FetchDescriptor<Domain>())
    let domain = domains?.first ?? Domain(name: "Work")
    return NavigationStack {
        DomainDetailView(domain: domain, year: 2026)
    }
    .modelContainer(container)
}

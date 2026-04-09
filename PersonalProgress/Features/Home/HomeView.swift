import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Domain.sortOrder) private var domains: [Domain]
    @Query(sort: \AnnualLetter.year, order: .reverse) private var letters: [AnnualLetter]
    @Environment(\.modelContext) private var modelContext

    private let reflectionService = ReflectionService()
    @State private var currentReflection: WeeklyReflection?
    private let currentYear = Date.now.calendarYear

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                    greetingSection
                    weeklyPrioritiesSection
                    domainsSection
                    upcomingCheckInSection
                }
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            .background(Color.surfaceGrouped)
            .navigationTitle("\(currentYear)")
            .navigationBarTitleDisplayMode(.large)
        }
        .task { await loadReflection() }
    }

    // MARK: - Sections

    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(Date.now.greetingText)
                .font(.headingSmall)
                .foregroundStyle(.textSecondary)
            if let letter = letters.first, let theme = letter.themeStatement {
                Text(theme)
                    .font(.displayMedium)
                    .italic()
            } else {
                Text("Personal Progress")
                    .font(.displayMedium)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
    }

    @ViewBuilder
    private var weeklyPrioritiesSection: some View {
        if let reflection = currentReflection {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                SectionHeader(title: "This Week", systemImage: "sparkles")
                    .padding(.horizontal, AppTheme.Spacing.xl)

                AppCard {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        HStack {
                            Text(reflection.weekStartDate.weekLabel)
                                .font(.captionSmall)
                                .foregroundStyle(.textTertiary)
                            Spacer()
                            if reflection.isLocked {
                                Image(systemName: "lock.fill")
                                    .font(.captionSmall)
                                    .foregroundStyle(.textTertiary)
                            }
                        }

                        if reflection.weeklyPriorities.filter({ !$0.isEmpty }).isEmpty {
                            Text("No priorities set yet. Tap Reflect to plan your week.")
                                .font(.bodySmall)
                                .foregroundStyle(.textTertiary)
                                .italic()
                        } else {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                ForEach(reflection.weeklyPriorities.filter { !$0.isEmpty }, id: \.self) { priority in
                                    HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                                        Circle()
                                            .fill(Color.appAccent)
                                            .frame(width: 5, height: 5)
                                            .padding(.top, 7)
                                        Text(priority)
                                            .font(.bodySmall)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
    }

    @ViewBuilder
    private var domainsSection: some View {
        let active = domains.filter { !$0.isArchived }
        if !active.isEmpty {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                SectionHeader(title: "Domains")
                    .padding(.horizontal, AppTheme.Spacing.xl)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.md) {
                        ForEach(active) { domain in
                            NavigationLink(destination: DomainDetailView(domain: domain, year: currentYear)) {
                                DomainChipCard(domain: domain, year: currentYear)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }
            }
        } else {
            EmptyStateView(
                systemImage: "square.grid.2x2",
                title: "No Domains Yet",
                message: "Complete onboarding to set up your life domains."
            )
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    @ViewBuilder
    private var upcomingCheckInSection: some View {
        let month = Calendar.current.component(.month, from: Date.now)
        if let quarter = Quarter.allCases.first(where: { month <= $0.endMonth }) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                SectionHeader(title: "Check-Ins")
                    .padding(.horizontal, AppTheme.Spacing.xl)

                AppCard {
                    HStack(spacing: AppTheme.Spacing.md) {
                        DomainIconBadge(iconName: "calendar.badge.checkmark", size: 44)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(quarter.displayName) Review")
                                .font(.headingSmall)
                            Text(quarter.months)
                                .font(.captionSmall)
                                .foregroundStyle(.textSecondary)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
    }

    private func loadReflection() async {
        currentReflection = try? reflectionService.currentWeekReflection(in: modelContext)
    }
}

// MARK: - Domain Chip Card

struct DomainChipCard: View {
    let domain: Domain
    let year: Int

    private var plan: DomainPlan? { domain.plan(forYear: year) }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            DomainIconBadge(iconName: DomainIcon(rawValue: domain.iconName)?.rawValue ?? "star", size: 36)

            Text(domain.name)
                .font(.headingSmall)
                .lineLimit(1)

            if let identity = plan?.identityStatement, !identity.isEmpty {
                Text(identity)
                    .font(.captionSmall)
                    .foregroundStyle(.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(width: 140, alignment: .leading)
        .padding(AppTheme.Spacing.md)
        .background(Color.surfaceBase)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - DomainRowView (used by other views)

struct DomainRowView: View {
    let domain: Domain
    let year: Int

    private var plan: DomainPlan? { domain.plan(forYear: year) }

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            DomainIconBadge(iconName: DomainIcon(rawValue: domain.iconName)?.rawValue ?? "star", size: 36)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(domain.name)
                    .font(.headingSmall)

                if let identity = plan?.identityStatement, !identity.isEmpty {
                    Text(identity)
                        .font(.bodySmall)
                        .foregroundStyle(.textSecondary)
                        .lineLimit(2)
                } else {
                    Text("Tap to set your intentions")
                        .font(.bodySmall)
                        .foregroundStyle(.textTertiary)
                }
            }
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }
}

#Preview {
    HomeView()
        .modelContainer(PersistenceController.preview.container)
}

import SwiftUI
import SwiftData

struct YearView: View {
    @Query(sort: \AnnualLetter.year, order: .reverse) private var letters: [AnnualLetter]
    @Query(sort: \Domain.sortOrder) private var domains: [Domain]
    @Environment(\.modelContext) private var modelContext

    private let currentYear = Date.now.calendarYear
    private let accountability = AccountabilityService.shared

    private var currentLetter: AnnualLetter? { letters.first { $0.year == currentYear } }
    private var activeDomains: [Domain] { domains.filter { !$0.isArchived } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                    visionSection
                    statusSummarySection
                    domainsSection
                }
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            .background(Color.surfaceGrouped)
            .navigationTitle("\(currentYear)")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Vision

    private var visionSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Annual Vision")
                .padding(.horizontal, AppTheme.Spacing.xl)

            if let letter = currentLetter {
                AppCard {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        if let word = letter.yearWord, !word.isEmpty {
                            Text(word.uppercased())
                                .font(.captionSmall.weight(.bold))
                                .foregroundStyle(Color.appAccent)
                                .kerning(1.2)
                        }

                        if let theme = letter.themeStatement, !theme.isEmpty {
                            Text(theme)
                                .font(.headingMedium)
                                .italic()
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text(letter.displayTitle)
                                .font(.headingMedium)
                        }

                        if !letter.rawText.isEmpty {
                            Text(letter.rawText.prefix(200) + (letter.rawText.count > 200 ? "…" : ""))
                                .font(.bodySmall)
                                .foregroundStyle(.textSecondary)
                                .lineLimit(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        HStack {
                            Spacer()
                            NavigationLink("Read Full Letter") {
                                LetterDetailView(letter: letter)
                            }
                            .font(.captionMedium)
                            .foregroundStyle(Color.appAccent)
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            } else {
                EmptyStateView(
                    systemImage: "envelope",
                    title: "No Annual Letter",
                    message: "Write your annual vision to anchor the year ahead."
                )
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
    }

    // MARK: - Status Summary

    @ViewBuilder
    private var statusSummarySection: some View {
        if !activeDomains.isEmpty {
            let summary = accountability.yearSummary(
                domains: activeDomains,
                year: currentYear,
                context: modelContext
            )

            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                SectionHeader(title: "Year At a Glance")
                    .padding(.horizontal, AppTheme.Spacing.xl)

                AppCard {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text(summary.headline)
                            .font(.headingSmall)

                        HStack(spacing: AppTheme.Spacing.lg) {
                            if summary.onTrackCount > 0 {
                                StatusCountChip(count: summary.onTrackCount, label: "On Track", style: .onTrack)
                            }
                            if summary.atRiskCount > 0 {
                                StatusCountChip(count: summary.atRiskCount, label: "At Risk", style: .atRisk)
                            }
                            if summary.neglectedCount > 0 {
                                StatusCountChip(count: summary.neglectedCount, label: "Neglected", style: .neglected)
                            }
                            if summary.newCount > 0 {
                                StatusCountChip(count: summary.newCount, label: "New", style: .neutral)
                            }
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
    }

    // MARK: - Domains

    @ViewBuilder
    private var domainsSection: some View {
        if !activeDomains.isEmpty {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                SectionHeader(title: "Domains")
                    .padding(.horizontal, AppTheme.Spacing.xl)

                VStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(activeDomains) { domain in
                        NavigationLink(destination: DomainDetailView(domain: domain, year: currentYear)) {
                            DomainYearRow(domain: domain, year: currentYear, context: modelContext)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                    }
                }
            }
        }
    }
}

// MARK: - DomainYearRow

private struct DomainYearRow: View {
    let domain: Domain
    let year: Int
    let context: ModelContext

    private var plan: DomainPlan? { domain.plan(forYear: year) }
    private var status: DomainStatus {
        AccountabilityService.shared.status(for: domain, year: year, context: context)
    }

    var body: some View {
        AppCard {
            HStack(spacing: AppTheme.Spacing.md) {
                DomainIconBadge(
                    iconName: DomainIcon(rawValue: domain.iconName)?.rawValue ?? "star.fill",
                    size: 40
                )

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(domain.name)
                        .font(.headingSmall)

                    if let identity = plan?.identityStatement, !identity.isEmpty {
                        Text(identity)
                            .font(.captionMedium)
                            .foregroundStyle(.textSecondary)
                            .lineLimit(1)
                    } else {
                        Text("No identity statement yet")
                            .font(.captionMedium)
                            .foregroundStyle(.textTertiary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                    StatusPill(style: status.statusPillStyle)
                    if let plan {
                        let count = plan.activeIntentions.count
                        if count > 0 {
                            Text("\(count) intention\(count == 1 ? "" : "s")")
                                .font(.captionSmall)
                                .foregroundStyle(.textTertiary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - StatusCountChip

private struct StatusCountChip: View {
    let count: Int
    let label: String
    let style: StatusPillStyle

    var body: some View {
        VStack(spacing: 2) {
            Text("\(count)")
                .font(.headingMedium)
                .foregroundStyle(style.color)
            Text(label)
                .font(.captionSmall)
                .foregroundStyle(.textTertiary)
        }
    }
}

// MARK: - LetterDetailView

struct LetterDetailView: View {
    let letter: AnnualLetter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                if let word = letter.yearWord, !word.isEmpty {
                    Text(word.uppercased())
                        .font(.captionSmall.weight(.bold))
                        .foregroundStyle(Color.appAccent)
                        .kerning(1.2)
                }

                if let theme = letter.themeStatement, !theme.isEmpty {
                    Text(theme)
                        .font(.displayMedium)
                        .italic()
                }

                Text(letter.rawText)
                    .font(.bodyMedium)
                    .foregroundStyle(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(AppTheme.Spacing.xl)
        }
        .background(Color.surfaceGrouped)
        .navigationTitle(letter.displayTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    YearView()
        .modelContainer(PersistenceController.preview.container)
}

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Domain.sortOrder) private var domains: [Domain]
    @Environment(\.modelContext) private var modelContext

    private let currentYear = Date.now.calendarYear

    var body: some View {
        NavigationStack {
            List {
                if domains.isEmpty {
                    ContentUnavailableView(
                        "No Domains Yet",
                        systemImage: "square.grid.2x2",
                        description: Text("Complete onboarding to set up your life domains.")
                    )
                } else {
                    ForEach(domains.filter { !$0.isArchived }) { domain in
                        NavigationLink(destination: DomainDetailView(domain: domain, year: currentYear)) {
                            DomainRowView(domain: domain, year: currentYear)
                        }
                    }
                }
            }
            .navigationTitle("\(currentYear)")
        }
    }
}

// MARK: - DomainRowView

struct DomainRowView: View {
    let domain: Domain
    let year: Int

    private var plan: DomainPlan? {
        domain.plan(forYear: year)
    }

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: domain.iconName)
                .font(.headingMedium)
                .foregroundStyle(Color.appAccent)
                .frame(width: 32)

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

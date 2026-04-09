import SwiftUI
import SwiftData

struct DomainDetailView: View {
    let domain: Domain
    let year: Int

    private var plan: DomainPlan? {
        domain.plan(forYear: year)
    }

    var body: some View {
        List {
            if let plan {
                // Identity
                if !plan.identityStatement.isEmpty {
                    Section("Identity") {
                        Text(plan.identityStatement)
                            .font(.bodyMedium)
                            .foregroundStyle(.textSecondary)
                    }
                }

                // Success Definitions
                if !plan.successDefinitions.isEmpty {
                    Section("I will know I succeeded if…") {
                        ForEach(plan.successDefinitions.sorted(by: { $0.sortOrder < $1.sortOrder })) { def in
                            Text(def.text)
                                .font(.bodyMedium)
                        }
                    }
                }

                // Intentions by type
                for intentionType in IntentionType.allCases {
                    let filtered = plan.intentions(ofType: intentionType).filter { !$0.isArchived }
                    if !filtered.isEmpty {
                        Section(intentionType.displayName) {
                            ForEach(filtered.sorted(by: { $0.sortOrder < $1.sortOrder })) { intention in
                                IntentionRowView(intention: intention)
                            }
                        }
                    }
                }
            } else {
                ContentUnavailableView(
                    "No Plan for \(year)",
                    systemImage: "doc.badge.plus",
                    description: Text("Add this domain to your annual letter to set intentions.")
                )
            }
        }
        .navigationTitle(domain.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - IntentionRowView

struct IntentionRowView: View {
    let intention: Intention

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: intention.type.systemImage)
                .font(.bodySmall)
                .foregroundStyle(Color.appAccent)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(intention.title)
                    .font(.bodyMedium)

                if let note = intention.note {
                    Text(note)
                        .font(.captionMedium)
                        .foregroundStyle(.textSecondary)
                }

                if let frequency = intention.frequency {
                    Text(frequency.displayName)
                        .font(.captionSmall)
                        .foregroundStyle(.textTertiary)
                }
            }
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

import SwiftUI
import SwiftData

struct ReflectionHistoryView: View {
    @Query(sort: \WeeklyReflection.weekStartDate, order: .reverse)
    private var reflections: [WeeklyReflection]

    var body: some View {
        Group {
            if reflections.isEmpty {
                EmptyStateView(
                    systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                    title: "No Past Reflections",
                    message: "Completed reflections will appear here."
                )
            } else {
                List {
                    ForEach(reflections) { reflection in
                        NavigationLink(destination: ReflectionDetailView(reflection: reflection)) {
                            reflectionRow(reflection)
                        }
                    }
                }
            }
        }
        .navigationTitle("Reflection History")
        .navigationBarTitleDisplayMode(.large)
    }

    private func reflectionRow(_ reflection: WeeklyReflection) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(reflection.weekStartDate.weekLabel)
                    .font(.bodyMedium)
                    .foregroundStyle(.textPrimary)
                Text("Week \(reflection.weekNumber) · \(reflection.year)")
                    .font(.captionMedium)
                    .foregroundStyle(.textSecondary)
            }
            Spacer()
            if reflection.isLocked {
                Image(systemName: "lock.fill")
                    .font(.captionSmall)
                    .foregroundStyle(.textTertiary)
            }
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }
}

#Preview {
    NavigationStack {
        ReflectionHistoryView()
    }
    .modelContainer(PersistenceController.preview.container)
}

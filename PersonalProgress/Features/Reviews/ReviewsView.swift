import SwiftUI
import SwiftData

struct ReviewsView: View {
    @Query(sort: \QuarterlyReview.year, order: .reverse) private var reviews: [QuarterlyReview]
    @Environment(\.modelContext) private var modelContext

    private let reviewService = ReviewService()

    var body: some View {
        NavigationStack {
            List {
                if reviews.isEmpty {
                    ContentUnavailableView(
                        "No Reviews Yet",
                        systemImage: "calendar.badge.checkmark",
                        description: Text("Your quarterly reviews will appear here.")
                    )
                } else {
                    ForEach(reviews) { review in
                        NavigationLink(destination: QuarterlyReviewDetailView(review: review)) {
                            QuarterlyReviewRowView(review: review)
                        }
                    }
                }
            }
            .navigationTitle("Reviews")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - QuarterlyReviewRowView

struct QuarterlyReviewRowView: View {
    let review: QuarterlyReview

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack {
                Text("\(review.quarter.displayName) \(review.year)")
                    .font(.headingSmall)
                Spacer()
                if review.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.captionSmall)
                        .foregroundStyle(.textTertiary)
                }
            }
            Text(review.quarter.months)
                .font(.captionMedium)
                .foregroundStyle(.textSecondary)
        }
    }
}

// MARK: - QuarterlyReviewDetailView

struct QuarterlyReviewDetailView: View {
    @Bindable var review: QuarterlyReview

    var body: some View {
        List {
            Section {
                Text("\(review.quarter.displayName) \(review.year)")
                    .font(.headingMedium)
                Text(review.quarter.months)
                    .font(.bodySmall)
                    .foregroundStyle(.textSecondary)
            }

            Section("Overall Reflection") {
                TextEditor(text: Binding(
                    get: { review.overallReflectionText ?? "" },
                    set: { review.overallReflectionText = $0.isEmpty ? nil : $0 }
                ))
                .frame(minHeight: 100)
                .disabled(review.isLocked)
            }

            Section("Quarter Highlight") {
                TextField("Most important thing accomplished…", text: Binding(
                    get: { review.quarterHighlight ?? "" },
                    set: { review.quarterHighlight = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
                .disabled(review.isLocked)
            }

            Section("Key Adjustment") {
                TextField("One thing I will do differently…", text: Binding(
                    get: { review.keyAdjustment ?? "" },
                    set: { review.keyAdjustment = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
                .disabled(review.isLocked)
            }

            Toggle("Re-read annual letter", isOn: $review.letterWasReRead)
                .disabled(review.isLocked)
        }
        .navigationTitle("\(review.quarter.displayName) Review")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ReviewsView()
        .modelContainer(PersistenceController.preview.container)
}

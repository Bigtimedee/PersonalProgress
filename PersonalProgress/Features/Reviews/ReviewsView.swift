import SwiftUI
import SwiftData

struct ReviewsView: View {
    @Query(sort: \QuarterlyReview.year, order: .reverse) private var reviews: [QuarterlyReview]

    private let reviewService = ReviewService()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                    if reviews.isEmpty {
                        EmptyStateView(
                            systemImage: "calendar.badge.checkmark",
                            title: "No Reviews Yet",
                            message: "Your quarterly reviews will appear here as you complete them."
                        )
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding(.top, AppTheme.Spacing.xxl)
                    } else {
                        reviewsList
                    }
                }
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            .background(Color.surfaceGrouped)
            .navigationTitle("Reviews")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var reviewsList: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Quarterly Reviews")
                .padding(.horizontal, AppTheme.Spacing.xl)

            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(reviews) { review in
                    NavigationLink(destination: QuarterlyReviewDetailView(review: review)) {
                        QuarterlyReviewRowView(review: review)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }
            }
        }
    }
}

// MARK: - QuarterlyReviewRowView

struct QuarterlyReviewRowView: View {
    let review: QuarterlyReview

    var body: some View {
        AppCard {
            HStack(spacing: AppTheme.Spacing.md) {
                DomainIconBadge(iconName: "calendar.badge.checkmark", size: 40)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("\(review.quarter.displayName) \(review.year)")
                        .font(.headingSmall)
                    Text(review.quarter.months)
                        .font(.captionMedium)
                        .foregroundStyle(.textSecondary)
                }

                Spacer()

                if review.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.captionSmall)
                        .foregroundStyle(.textTertiary)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.captionSmall)
                        .foregroundStyle(.textTertiary)
                }
            }
        }
    }
}

// MARK: - QuarterlyReviewDetailView

struct QuarterlyReviewDetailView: View {
    @Bindable var review: QuarterlyReview

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                headerCard
                if review.isLocked {
                    LockBanner()
                        .padding(.horizontal, AppTheme.Spacing.xl)
                }
                overallReflectionSection
                highlightSection
                adjustmentSection
                letterSection
            }
            .padding(.vertical, AppTheme.Spacing.lg)
        }
        .background(Color.surfaceGrouped)
        .navigationTitle("\(review.quarter.displayName) Review")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Header

    private var headerCard: some View {
        AppCard {
            HStack(spacing: AppTheme.Spacing.md) {
                DomainIconBadge(iconName: "calendar.badge.checkmark", size: 52)
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("\(review.quarter.displayName) \(review.year)")
                        .font(.headingLarge)
                    Text(review.quarter.months)
                        .font(.captionMedium)
                        .foregroundStyle(.textSecondary)
                }
                Spacer()
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
    }

    // MARK: - Overall Reflection

    private var overallReflectionSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Overall Reflection")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    FormFieldLabel(title: "How did the quarter go?")
                    TextEditor(text: Binding(
                        get: { review.overallReflectionText ?? "" },
                        set: { review.overallReflectionText = $0.isEmpty ? nil : $0 }
                    ))
                    .frame(minHeight: 100)
                    .font(.bodySmall)
                    .disabled(review.isLocked)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Highlight

    private var highlightSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Quarter Highlight")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    FormFieldLabel(title: "Most important thing accomplished")
                    TextField("What are you most proud of?", text: Binding(
                        get: { review.quarterHighlight ?? "" },
                        set: { review.quarterHighlight = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .font(.bodySmall)
                    .disabled(review.isLocked)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Key Adjustment

    private var adjustmentSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Course Correction")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    FormFieldLabel(title: "One thing to do differently next quarter")
                    TextField("What would you change?", text: Binding(
                        get: { review.keyAdjustment ?? "" },
                        set: { review.keyAdjustment = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .font(.bodySmall)
                    .disabled(review.isLocked)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Annual Letter

    private var letterSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Annual Alignment")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                HStack {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        Text("Re-read annual letter")
                            .font(.bodyMedium)
                        Text("Stay connected to your yearly vision")
                            .font(.captionMedium)
                            .foregroundStyle(.textSecondary)
                    }
                    Spacer()
                    Toggle("", isOn: $review.letterWasReRead)
                        .disabled(review.isLocked)
                        .labelsHidden()
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }
}

#Preview {
    ReviewsView()
        .modelContainer(PersistenceController.preview.container)
}

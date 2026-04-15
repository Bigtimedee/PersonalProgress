import SwiftUI
import SwiftData

// MARK: - LetterView (tab root)

struct LetterView: View {
    @Query(sort: \AnnualLetter.year, order: .reverse) private var letters: [AnnualLetter]

    var body: some View {
        NavigationStack {
            if let current = letters.first {
                LetterReadingView(letter: current)
                    .toolbar {
                        if letters.count > 1 {
                            ToolbarItem(placement: .topBarLeading) {
                                NavigationLink(destination: LetterArchiveView()) {
                                    Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                                }
                            }
                        }
                    }
            } else {
                ContentUnavailableView(
                    "No Letter Yet",
                    systemImage: "doc.text",
                    description: Text("Complete onboarding to write your annual letter.")
                )
                .navigationTitle("My Letter")
            }
        }
    }
}

// MARK: - LetterReadingView

private struct ScrollOffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

private struct ContentHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

private struct ViewportHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

struct LetterReadingView: View {
    @Bindable var letter: AnnualLetter
    @State private var showEditSheet = false
    @State private var scrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var viewportHeight: CGFloat = 0
    @State private var showScrollTop = false

    private var readingProgress: CGFloat {
        let scrollable = contentHeight - viewportHeight
        guard scrollable > 0 else { return 1 }
        return CGFloat(min(1, max(0, Double(-scrollOffset / scrollable))))
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear.frame(height: 0).id("letterTop")
                        letterContent
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(key: ContentHeightKey.self, value: geo.size.height)
                                }
                            )
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetKey.self,
                                    value: geo.frame(in: .named("letterScroll")).minY
                                )
                        }
                    )
                }
                .coordinateSpace(name: "letterScroll")
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ViewportHeightKey.self, value: geo.size.height)
                    }
                )
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    scrollOffset = value
                    withAnimation(AppTheme.Animation.quick) {
                        showScrollTop = value < -100
                    }
                }
                .onPreferenceChange(ContentHeightKey.self) { value in
                    contentHeight = value
                }
                .onPreferenceChange(ViewportHeightKey.self) { value in
                    viewportHeight = value
                }
                .overlay(alignment: .bottomTrailing) {
                    if showScrollTop {
                        Button {
                            withAnimation { proxy.scrollTo("letterTop") }
                        } label: {
                            Image(systemName: "chevron.up")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.appAccent.opacity(0.85), in: Circle())
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                        }
                        .padding(AppTheme.Spacing.xl)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }

            // Reading progress bar — top of content area
            GeometryReader { geo in
                Rectangle()
                    .fill(Color.appAccent.opacity(0.35))
                    .frame(width: geo.size.width * readingProgress, height: 2)
                    .animation(nil, value: readingProgress)
            }
            .frame(height: 2)
        }
        .navigationTitle(letter.displayTitle)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if !letter.isSealed {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") { showEditSheet = true }
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            LetterEditView(letter: letter)
        }
    }

    // MARK: - Letter Content

    private var letterContent: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
            // Hero header
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                if let yearWord = letter.yearWord, !yearWord.isEmpty {
                    Text(yearWord.uppercased())
                        .font(.captionSmall)
                        .foregroundStyle(.appAccent)
                        .tracking(2)
                }

                if !letter.title.isEmpty {
                    Text(letter.title)
                        .font(.displayLarge)
                }

                if let theme = letter.themeStatement, !theme.isEmpty {
                    Text(theme)
                        .font(.bodyMedium)
                        .foregroundStyle(.textSecondary)
                        .italic()
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if letter.isSealed {
                HStack(spacing: AppTheme.Spacing.xs) {
                    Image(systemName: "lock.fill")
                    Text("Sealed")
                }
                .font(.captionSmall)
                .foregroundStyle(.textTertiary)
            }

            Divider()

            if letter.rawText.isEmpty {
                Text("No letter content yet. Tap Edit to write your annual letter.")
                    .font(.letterBody)
                    .foregroundStyle(.textTertiary)
                    .italic()
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text(letter.rawText)
                    .font(.letterBody)
                    .lineSpacing(6)
                    .foregroundStyle(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: AppTheme.Spacing.xxl)
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.vertical, AppTheme.Spacing.xl)
    }
}

// MARK: - Preview

#Preview {
    LetterView()
        .modelContainer(PersistenceController.preview.container)
}

import SwiftUI
import SwiftData

/// The onboarding flow shown to new users.
/// It guides the user through:
/// 1. A welcome screen explaining the app's purpose
/// 2. Writing (or pasting) their annual letter
/// 3. Setting up their life domains
/// 4. Entering their identity statements and success definitions per domain
///
/// Onboarding is complete when the user has at least one AnnualLetter in the database.
struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentPage = 0
    @State private var letterText = ""
    @State private var selectedDomainNames: Set<String> = []

    private let letterService = LetterService()
    private let domainService = DomainService()
    private let currentYear = Date.now.calendarYear

    var body: some View {
        TabView(selection: $currentPage) {
            WelcomePageView(onNext: { currentPage = 1 })
                .tag(0)

            LetterPageView(letterText: $letterText, onNext: { currentPage = 2 })
                .tag(1)

            DomainsPageView(
                selectedNames: $selectedDomainNames,
                onFinish: completeOnboarding
            )
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.standard, value: currentPage)
    }

    private func completeOnboarding() {
        do {
            let letter = try letterService.createLetter(
                year: currentYear,
                rawText: letterText,
                in: modelContext
            )
            _ = letter

            for (index, name) in selectedDomainNames.sorted().enumerated() {
                let icon = Constants.Defaults.suggestedDomains.first(where: { $0.name == name })?.icon ?? .star
                let domain = try domainService.createDomain(
                    name: name,
                    iconName: icon.rawValue,
                    sortOrder: index,
                    in: modelContext
                )
                _ = try domainService.createDomainPlan(
                    for: domain,
                    year: currentYear,
                    in: modelContext
                )
            }
        } catch {
            // TODO: surface error to user in Phase 3
        }
    }
}

// MARK: - WelcomePageView

struct WelcomePageView: View {
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()
            Image(systemName: "envelope.open.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.appAccent)

            Text("Personal Progress")
                .font(.displayLarge)

            Text("Your annual letter. Alive for the full 52 weeks.")
                .font(.bodyLarge)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xxl)

            Spacer()

            Button("Get Started") {
                onNext()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
    }
}

// MARK: - LetterPageView

struct LetterPageView: View {
    @Binding var letterText: String
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Text("Your Annual Letter")
                .font(.displayMedium)
                .padding(.top, AppTheme.Spacing.xxl)

            Text("Paste or type your planning letter. You can always edit it later.")
                .font(.bodyMedium)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xl)

            TextEditor(text: $letterText)
                .font(.letterBody)
                .padding(AppTheme.Spacing.md)
                .background(Color.surfaceElevated)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
                .padding(.horizontal, AppTheme.Spacing.md)

            Button("Continue") {
                onNext()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.xxl)
            .disabled(letterText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

// MARK: - DomainsPageView

struct DomainsPageView: View {
    @Binding var selectedNames: Set<String>
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Text("Your Life Domains")
                .font(.displayMedium)
                .padding(.top, AppTheme.Spacing.xxl)

            Text("Choose the domains you want to track. You can add or change these later.")
                .font(.bodyMedium)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xl)

            List {
                ForEach(Constants.Defaults.suggestedDomains, id: \.name) { item in
                    Button {
                        if selectedNames.contains(item.name) {
                            selectedNames.remove(item.name)
                        } else {
                            selectedNames.insert(item.name)
                        }
                    } label: {
                        HStack {
                            Image(systemName: item.icon.rawValue)
                                .frame(width: 24)
                            Text(item.name)
                            Spacer()
                            if selectedNames.contains(item.name) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.appAccent)
                            }
                        }
                        .foregroundStyle(.textPrimary)
                    }
                }
            }

            Button("Open My Year") {
                onFinish()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.xxl)
            .disabled(selectedNames.isEmpty)
        }
    }
}

#Preview {
    OnboardingView()
        .modelContainer(PersistenceController.preview.container)
}

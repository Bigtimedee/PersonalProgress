import SwiftUI
import SwiftData

// MARK: - OnboardingStep

enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case philosophy
    case annualVision
    case domains
    case successDefinitions
    case quarterlyDates
    case confirmation

    var title: String {
        switch self {
        case .welcome:           return ""
        case .philosophy:        return "The Practice"
        case .annualVision:      return "Your Annual Vision"
        case .domains:           return "Your Life Domains"
        case .successDefinitions: return "Defining Success"
        case .quarterlyDates:    return "Quarterly Check-Ins"
        case .confirmation:      return "You're Ready"
        }
    }

    /// Number of steps that show a progress indicator (all except welcome/confirmation)
    static let progressSteps: [OnboardingStep] = [.philosophy, .annualVision, .domains, .successDefinitions, .quarterlyDates]
}

// MARK: - OnboardingView

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var step: OnboardingStep = .welcome
    @State private var letterText = ""
    @State private var themeStatement = ""
    @State private var selectedDomainNames: Set<String> = []
    @State private var successDefinitionsByDomain: [String: [String]] = [:]
    @State private var quarterlyDates: [Quarter: Date] = Self.defaultQuarterlyDates()

    private let letterService = LetterService()
    private let domainService = DomainService()
    private let currentYear = Date.now.calendarYear

    // MARK: - Layout

    var body: some View {
        ZStack(alignment: .top) {
            Color.surfaceBase.ignoresSafeArea()

            VStack(spacing: 0) {
                if OnboardingStep.progressSteps.contains(step) {
                    OnboardingProgressBar(step: step)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding(.top, AppTheme.Spacing.lg)
                        .transition(.opacity)
                }

                stepView
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .animation(AppTheme.Animation.standard, value: step)
    }

    // MARK: - Step routing

    @ViewBuilder
    private var stepView: some View {
        switch step {
        case .welcome:
            WelcomeStep(onNext: advance)

        case .philosophy:
            PhilosophyStep(onNext: advance)

        case .annualVision:
            AnnualVisionStep(
                letterText: $letterText,
                themeStatement: $themeStatement,
                onNext: advance
            )

        case .domains:
            DomainsStep(
                selectedNames: $selectedDomainNames,
                onNext: advance
            )

        case .successDefinitions:
            SuccessDefinitionsStep(
                selectedDomains: selectedDomainNames,
                definitions: $successDefinitionsByDomain,
                onNext: advance
            )

        case .quarterlyDates:
            QuarterlyDatesStep(
                dates: $quarterlyDates,
                currentYear: currentYear,
                onNext: advance
            )

        case .confirmation:
            ConfirmationStep(
                domainCount: selectedDomainNames.count,
                onFinish: completeOnboarding
            )
        }
    }

    // MARK: - Navigation

    private func advance() {
        guard let next = OnboardingStep(rawValue: step.rawValue + 1) else { return }
        withAnimation(AppTheme.Animation.standard) { step = next }
    }

    // MARK: - Persistence

    private func completeOnboarding() {
        do {
            let letter = try letterService.createLetter(
                year: currentYear,
                rawText: letterText,
                in: modelContext
            )
            if !themeStatement.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                letter.themeStatement = themeStatement.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            _ = letter

            for (index, name) in selectedDomainNames.sorted().enumerated() {
                let icon = Constants.Defaults.suggestedDomains.first(where: { $0.name == name })?.icon ?? .star
                let domain = try domainService.createDomain(
                    name: name,
                    iconName: icon.rawValue,
                    sortOrder: index,
                    in: modelContext
                )
                let plan = try domainService.createDomainPlan(
                    for: domain,
                    year: currentYear,
                    in: modelContext
                )
                let defs = successDefinitionsByDomain[name] ?? []
                for (_, defText) in defs.enumerated() {
                    let trimmed = defText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { continue }
                    _ = try domainService.addSuccessDefinition(
                        text: trimmed,
                        to: plan,
                        in: modelContext
                    )
                }
            }
        } catch {
            // TODO: surface error to user in Phase 3
        }
    }

    // MARK: - Helpers

    private static func defaultQuarterlyDates() -> [Quarter: Date] {
        let year = Date.now.calendarYear
        var result: [Quarter: Date] = [:]
        for quarter in Quarter.allCases {
            var components = DateComponents()
            components.year = year
            components.month = quarter.endMonth
            components.day = 15
            result[quarter] = Calendar.current.date(from: components)
        }
        return result
    }
}

// MARK: - Progress Bar

private struct OnboardingProgressBar: View {
    let step: OnboardingStep

    private var progressIndex: Int {
        OnboardingStep.progressSteps.firstIndex(of: step) ?? 0
    }

    private var total: Int { OnboardingStep.progressSteps.count }

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index <= progressIndex ? Color.appAccent : Color.surfaceElevated)
                    .frame(height: 3)
            }
        }
        .animation(AppTheme.Animation.standard, value: progressIndex)
    }
}

// MARK: - Step 0: Welcome

private struct WelcomeStep: View {
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: AppTheme.Spacing.lg) {
                Image(systemName: "envelope.open.fill")
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(Color.appAccent)

                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("Personal Progress")
                        .font(.displayLarge)
                        .multilineTextAlignment(.center)

                    Text("Your annual letter.\nAlive for the full 52 weeks.")
                        .font(.bodyLarge)
                        .foregroundStyle(.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }

            Spacer()
            Spacer()

            VStack(spacing: AppTheme.Spacing.md) {
                OnboardingPrimaryButton(label: "Begin", action: onNext)
                Text("Takes about 10 minutes")
                    .font(.captionMedium)
                    .foregroundStyle(.textTertiary)
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
    }
}

// MARK: - Step 1: Philosophy

private struct PhilosophyStep: View {
    let onNext: () -> Void

    private let principles: [(icon: String, heading: String, body: String)] = [
        ("envelope.open",
         "Write it once, live with it all year",
         "Your annual letter sets the tone for every decision you make over 52 weeks. It is not a task list — it is a compass."),
        ("arrow.triangle.2.circlepath",
         "Review without judgment",
         "Every week and every quarter you return to the same question: am I living the life I intended to live?"),
        ("lock.open",
         "Honest, private, and entirely yours",
         "Nothing leaves your device. No algorithms. No social features. Just you, your intentions, and your progress."),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxl) {
                OnboardingHeader(
                    headline: "A different kind of planning",
                    subheadline: "Most productivity systems optimize for speed. This one optimizes for meaning."
                )

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                    ForEach(principles, id: \.heading) { p in
                        HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                            Image(systemName: p.icon)
                                .font(.title3)
                                .foregroundStyle(Color.appAccent)
                                .frame(width: 28)
                                .padding(.top, 2)

                            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                                Text(p.heading)
                                    .font(.headingSmall)
                                Text(p.body)
                                    .font(.bodySmall)
                                    .foregroundStyle(.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
            .padding(.vertical, AppTheme.Spacing.lg)
        }
        .safeAreaInset(edge: .bottom) {
            OnboardingPrimaryButton(label: "I'm ready", action: onNext)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
                .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Step 2: Annual Vision

private struct AnnualVisionStep: View {
    @Binding var letterText: String
    @Binding var themeStatement: String
    let onNext: () -> Void

    @FocusState private var focusedField: Field?
    private enum Field { case theme, letter }

    private var canContinue: Bool {
        !letterText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                    OnboardingHeader(
                        headline: "Your Annual Vision",
                        subheadline: "Write, paste, or dictate your letter. It can be rough — you can refine it anytime."
                    )

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Theme or Word of the Year")
                            .font(.headingSmall)
                            .padding(.horizontal, AppTheme.Spacing.xl)
                        TextField("e.g. \"Intentionality\" or \"Year of Deep Work\"", text: $themeStatement)
                            .font(.bodyMedium)
                            .focused($focusedField, equals: .theme)
                            .padding(AppTheme.Spacing.md)
                            .background(Color.surfaceElevated)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
                            .padding(.horizontal, AppTheme.Spacing.xl)
                    }

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        HStack {
                            Text("Your Annual Letter")
                                .font(.headingSmall)
                            Spacer()
                            if letterText.isEmpty {
                                Text("Required")
                                    .font(.captionSmall)
                                    .foregroundStyle(Color.appAccent)
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.xl)

                        TextEditor(text: $letterText)
                            .font(.letterBody)
                            .focused($focusedField, equals: .letter)
                            .frame(minHeight: 240)
                            .padding(AppTheme.Spacing.md)
                            .background(Color.surfaceElevated)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
                            .padding(.horizontal, AppTheme.Spacing.xl)
                            .accessibilityIdentifier("onboarding.annualLetter")
                            .overlay(alignment: .topLeading) {
                                if letterText.isEmpty {
                                    Text("Write your vision for the year here — who you want to be, what matters most, what you are committed to…")
                                        .font(.letterBody)
                                        .foregroundStyle(.textTertiary)
                                        .padding(.horizontal, AppTheme.Spacing.xl + AppTheme.Spacing.md)
                                        .padding(.top, AppTheme.Spacing.md + AppTheme.Spacing.sm)
                                        .allowsHitTesting(false)
                                }
                            }
                    }
                }
                .padding(.vertical, AppTheme.Spacing.lg)
            }

            OnboardingPrimaryButton(label: "Set My Domains", action: onNext)
                .disabled(!canContinue)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
                .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Step 3: Domains

private struct DomainsStep: View {
    @Binding var selectedNames: Set<String>
    let onNext: () -> Void

    private var canContinue: Bool { !selectedNames.isEmpty }

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                headline: "Your Life Domains",
                subheadline: "Choose the areas of life you want to hold yourself to. Start with 4–6 domains."
            )
            .padding(.bottom, AppTheme.Spacing.sm)

            List {
                ForEach(Constants.Defaults.suggestedDomains, id: \.name) { item in
                    Button {
                        if selectedNames.contains(item.name) {
                            selectedNames.remove(item.name)
                        } else {
                            selectedNames.insert(item.name)
                        }
                    } label: {
                        HStack(spacing: AppTheme.Spacing.md) {
                            ZStack {
                                Circle()
                                    .fill(selectedNames.contains(item.name) ? Color.appAccent : Color.surfaceElevated)
                                    .frame(width: 36, height: 36)
                                Image(systemName: item.icon.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(selectedNames.contains(item.name) ? .white : .textSecondary)
                            }
                            Text(item.name)
                                .font(.bodyMedium)
                                .foregroundStyle(.textPrimary)
                            Spacer()
                            if selectedNames.contains(item.name) {
                                Image(systemName: "checkmark")
                                    .font(.callout.weight(.semibold))
                                    .foregroundStyle(Color.appAccent)
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.xs)
                    }
                    .listRowBackground(Color.surfaceBase)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)

            VStack(spacing: AppTheme.Spacing.xs) {
                OnboardingPrimaryButton(label: "Define Success", action: onNext)
                    .disabled(!canContinue)
                if selectedNames.isEmpty {
                    Text("Select at least one domain to continue")
                        .font(.captionSmall)
                        .foregroundStyle(.textTertiary)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.lg)
            .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Step 4: Success Definitions

private struct SuccessDefinitionsStep: View {
    let selectedDomains: Set<String>
    @Binding var definitions: [String: [String]]
    let onNext: () -> Void

    private var sortedDomains: [String] { selectedDomains.sorted() }

    private var canContinue: Bool {
        sortedDomains.allSatisfy { domain in
            let defs = definitions[domain] ?? []
            return defs.contains { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                    OnboardingHeader(
                        headline: "Defining Success",
                        subheadline: "For each domain, complete the sentence: \"I will know I succeeded if…\""
                    )

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                        ForEach(sortedDomains, id: \.self) { domain in
                            SuccessDefinitionCard(
                                domainName: domain,
                                definitions: Binding(
                                    get: { definitions[domain] ?? [""] },
                                    set: { definitions[domain] = $0 }
                                )
                            )
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }
                .padding(.vertical, AppTheme.Spacing.lg)
            }

            VStack(spacing: AppTheme.Spacing.xs) {
                OnboardingPrimaryButton(label: "Set Check-In Dates", action: onNext)
                    .disabled(!canContinue)
                if !canContinue {
                    Text("Add at least one definition per domain")
                        .font(.captionSmall)
                        .foregroundStyle(.textTertiary)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.lg)
            .background(.ultraThinMaterial)
        }
    }
}

private struct SuccessDefinitionCard: View {
    let domainName: String
    @Binding var definitions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(domainName)
                .font(.headingSmall)

            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(definitions.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                        Text("•")
                            .font(.bodyMedium)
                            .foregroundStyle(Color.appAccent)
                            .padding(.top, 8)
                        TextField(
                            "I will know I succeeded if…",
                            text: Binding(
                                get: { definitions[index] },
                                set: { definitions[index] = $0 }
                            ),
                            axis: .vertical
                        )
                        .font(.bodyMedium)
                        if definitions.count > 1 {
                            Button {
                                definitions.remove(at: index)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.textTertiary)
                            }
                            .padding(.top, 6)
                        }
                    }
                }

                if definitions.count < 3 {
                    Button {
                        definitions.append("")
                    } label: {
                        Label("Add another", systemImage: "plus")
                            .font(.bodySmall)
                            .foregroundStyle(Color.appAccent)
                    }
                }
            }
            .padding(AppTheme.Spacing.md)
            .background(Color.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
        }
    }
}

// MARK: - Step 5: Quarterly Dates

private struct QuarterlyDatesStep: View {
    @Binding var dates: [Quarter: Date]
    let currentYear: Int
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                    OnboardingHeader(
                        headline: "Quarterly Check-Ins",
                        subheadline: "Set four dates now — one per quarter — when you will sit down and review your year."
                    )

                    VStack(spacing: AppTheme.Spacing.md) {
                        ForEach(Quarter.allCases, id: \.self) { quarter in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(quarter.displayName) — \(quarter.months)")
                                        .font(.bodyMedium)
                                    Text("Review date")
                                        .font(.captionSmall)
                                        .foregroundStyle(.textTertiary)
                                }
                                Spacer()
                                DatePicker(
                                    "",
                                    selection: Binding(
                                        get: { dates[quarter] ?? Date.now },
                                        set: { dates[quarter] = $0 }
                                    ),
                                    displayedComponents: .date
                                )
                                .labelsHidden()
                            }
                            .padding(AppTheme.Spacing.md)
                            .background(Color.surfaceElevated)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)

                    Text("These are reminders only. You can always change them in Settings.")
                        .font(.captionMedium)
                        .foregroundStyle(.textTertiary)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                }
                .padding(.vertical, AppTheme.Spacing.lg)
            }

            OnboardingPrimaryButton(label: "Almost Done", action: onNext)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
                .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Step 6: Confirmation

private struct ConfirmationStep: View {
    let domainCount: Int
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: AppTheme.Spacing.xl) {
                ZStack {
                    Circle()
                        .fill(Color.appAccent.opacity(0.12))
                        .frame(width: 96, height: 96)
                    Image(systemName: "checkmark")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(Color.appAccent)
                }

                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("You're ready.")
                        .font(.displayLarge)
                    Text("Your vision is set across \(domainCount) domain\(domainCount == 1 ? "" : "s").\nNow the real work begins.")
                        .font(.bodyLarge)
                        .foregroundStyle(.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    ConfirmationRow(icon: "house.fill", text: "Review your Home screen every morning")
                    ConfirmationRow(icon: "sparkles", text: "Reflect each Sunday evening")
                    ConfirmationRow(icon: "calendar.badge.checkmark", text: "Complete one quarterly review every 90 days")
                }
                .padding(AppTheme.Spacing.lg)
                .background(Color.surfaceElevated)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg))
                .padding(.horizontal, AppTheme.Spacing.xl)
            }

            Spacer()

            OnboardingPrimaryButton(label: "Open My Year", action: onFinish)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.bottom, AppTheme.Spacing.xxl)
        }
    }
}

private struct ConfirmationRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.callout)
                .foregroundStyle(Color.appAccent)
                .frame(width: 20)
            Text(text)
                .font(.bodySmall)
                .foregroundStyle(.textPrimary)
        }
    }
}

// MARK: - Shared Components

struct OnboardingHeader: View {
    let headline: String
    let subheadline: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(headline)
                .font(.displayMedium)
            Text(subheadline)
                .font(.bodyMedium)
                .foregroundStyle(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.top, AppTheme.Spacing.lg)
    }
}

struct OnboardingPrimaryButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(label, action: action)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview("Welcome") {
    OnboardingView()
        .modelContainer(PersistenceController.preview.container)
}

#Preview("Philosophy") {
    PhilosophyStep(onNext: {})
}

#Preview("Annual Vision") {
    AnnualVisionStep(
        letterText: .constant(""),
        themeStatement: .constant(""),
        onNext: {}
    )
}

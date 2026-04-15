import SwiftUI

// MARK: - AppCard

/// A clean, elevated card container. Use for dashboard sections and detail rows.
struct AppCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppTheme.Spacing.md)
            .background(Color.surfaceBase)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

// MARK: - SectionHeader

struct SectionHeader: View {
    let title: String
    var systemImage: String? = nil
    var action: (() -> Void)? = nil
    var actionLabel: String = "See All"

    var body: some View {
        HStack(alignment: .center) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(Color.appAccent)
            }
            Text(title.uppercased())
                .font(.captionSmall.weight(.semibold))
                .foregroundStyle(.textTertiary)
                .kerning(0.8)
            Spacer()
            if let action {
                Button(actionLabel, action: action)
                    .font(.captionMedium)
                    .foregroundStyle(Color.appAccent)
            }
        }
    }
}

// MARK: - StatusPill

enum StatusPillStyle {
    case onTrack, atRisk, neglected, complete, neutral

    var color: Color {
        switch self {
        case .onTrack:   return .green
        case .atRisk:    return .orange
        case .neglected: return .red
        case .complete:  return Color.appAccent
        case .neutral:   return .secondary
        }
    }

    var label: String {
        switch self {
        case .onTrack:   return "On Track"
        case .atRisk:    return "At Risk"
        case .neglected: return "Neglected"
        case .complete:  return "Complete"
        case .neutral:   return "In Progress"
        }
    }
}

struct StatusPill: View {
    let style: StatusPillStyle

    var body: some View {
        Text(style.label)
            .font(.captionSmall.weight(.semibold))
            .foregroundStyle(style.color)
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, 3)
            .background(style.color.opacity(0.12))
            .clipShape(Capsule())
    }
}

// MARK: - EmptyStateView

struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String
    var actionLabel: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: systemImage)
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(Color.appAccent.opacity(0.6))

            VStack(spacing: AppTheme.Spacing.sm) {
                Text(title)
                    .font(.headingMedium)
                Text(message)
                    .font(.bodySmall)
                    .foregroundStyle(.textSecondary)
                    .multilineTextAlignment(.center)
            }

            if let actionLabel, let action {
                Button(actionLabel, action: action)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
            }
        }
        .padding(AppTheme.Spacing.xxl)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - DomainIconBadge

struct DomainIconBadge: View {
    let iconName: String
    var size: CGFloat = 40
    var color: Color = .appAccent

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.12))
                .frame(width: size, height: size)
            Image(systemName: iconName)
                .font(.system(size: size * 0.42))
                .foregroundStyle(color)
        }
    }
}

// MARK: - PrimaryActionButton

struct PrimaryActionButton: View {
    let label: String
    var systemImage: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if let systemImage {
                Label(label, systemImage: systemImage)
            } else {
                Text(label)
            }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - SecondaryActionButton

struct SecondaryActionButton: View {
    let label: String
    var systemImage: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if let systemImage {
                Label(label, systemImage: systemImage)
            } else {
                Text(label)
            }
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - LockBanner

struct LockBanner: View {
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "lock.fill")
                .font(.captionSmall)
            Text("This record is locked and cannot be edited.")
                .font(.captionMedium)
        }
        .foregroundStyle(.textTertiary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.md)
        .background(Color.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
    }
}

// MARK: - FormFieldLabel

struct FormFieldLabel: View {
    let title: String
    var isRequired: Bool = false

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            Text(title)
                .font(.headingSmall)
            if isRequired {
                Text("Required")
                    .font(.captionSmall)
                    .foregroundStyle(Color.appAccent)
            }
        }
    }
}

// MARK: - RatingPicker

/// A 1–5 score picker for weekly domain self-assessment.
struct RatingPicker: View {
    let score: WeekScore?
    var isDisabled: Bool = false
    let onSelect: (WeekScore) -> Void

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            ForEach(WeekScore.allCases, id: \.self) { option in
                Button {
                    onSelect(option)
                } label: {
                    Text(option.symbol)
                        .font(.captionSmall.weight(.semibold))
                        .frame(width: 34, height: 34)
                        .background(score == option ? Color.appAccent : Color.surfaceElevated)
                        .foregroundStyle(score == option ? .white : Color.textSecondary)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .disabled(isDisabled)
            }
            if let score {
                Text(score.label)
                    .font(.captionSmall)
                    .foregroundStyle(.textTertiary)
                    .padding(.leading, AppTheme.Spacing.xs)
            }
        }
    }
}

// MARK: - Date extension for greeting

extension Date {
    var greetingText: String {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 5..<12:  return "Good morning"
        case 12..<17: return "Good afternoon"
        default:      return "Good evening"
        }
    }
}

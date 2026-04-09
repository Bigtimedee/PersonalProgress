import SwiftUI

// MARK: - ShapeStyle shorthand (enables .foregroundStyle(.textPrimary) syntax)

extension ShapeStyle where Self == Color {
    static var textPrimary: Color { .textPrimary }
    static var textSecondary: Color { .textSecondary }
    static var textTertiary: Color { Color(UIColor.tertiaryLabel) }
}

extension Color {

    // MARK: - Brand

    /// The app's primary accent color. Used for CTAs and emphasis.
    static let appAccent = Color("AppAccent", bundle: nil)

    // MARK: - Semantic aliases over system colors

    /// Primary text — high contrast, fully opaque.
    static let textPrimary = Color.primary

    /// Secondary text — reduced emphasis.
    static let textSecondary = Color.secondary

    /// Tertiary text — placeholder, metadata.
    static let textTertiary = Color(UIColor.tertiaryLabel)

    // MARK: - Surfaces

    static let surfaceBase = Color(UIColor.systemBackground)
    static let surfaceElevated = Color(UIColor.secondarySystemBackground)
    static let surfaceGrouped = Color(UIColor.systemGroupedBackground)

    // MARK: - Domain score colors

    static func scoreColor(for score: WeekScore) -> Color {
        switch score {
        case .poor: return .red
        case .belowExpectations: return .orange
        case .okay: return .yellow
        case .good: return .green
        case .excellent: return Color(red: 0.2, green: 0.8, blue: 0.4)
        }
    }

    static func accountabilityColor(for score: AccountabilityScore) -> Color {
        switch score {
        case .one: return .red
        case .two: return .orange
        case .three: return .yellow
        case .four: return .green
        case .five: return Color(red: 0.2, green: 0.8, blue: 0.4)
        }
    }
}

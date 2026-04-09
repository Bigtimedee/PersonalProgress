import SwiftUI

extension Font {

    // MARK: - Display

    /// Large hero text. Used for year headers, letter title.
    static let displayLarge = Font.system(size: 34, weight: .bold, design: .default)

    /// Medium display text.
    static let displayMedium = Font.system(size: 28, weight: .semibold, design: .default)

    // MARK: - Heading

    static let headingLarge = Font.system(size: 22, weight: .semibold, design: .default)
    static let headingMedium = Font.system(size: 18, weight: .semibold, design: .default)
    static let headingSmall = Font.system(size: 15, weight: .semibold, design: .default)

    // MARK: - Body

    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)

    // MARK: - Caption

    static let captionMedium = Font.system(size: 12, weight: .regular, design: .default)
    static let captionSmall = Font.system(size: 11, weight: .regular, design: .default)

    // MARK: - Letter body

    /// Used when displaying the annual letter text. Slightly larger for reading comfort.
    static let letterBody = Font.system(size: 17, weight: .regular, design: .serif)
}

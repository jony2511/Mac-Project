import SwiftUI

enum AppSpacing {
    static let xSmall: CGFloat = 6
    static let small: CGFloat = 10
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
}

enum AppCorners {
    static let card: CGFloat = 18
    static let hero: CGFloat = 26
}

enum AppColors {
    static let pageBase = Color(red: 0.06, green: 0.08, blue: 0.12)
    static let pageTopGlow = Color(red: 0.20, green: 0.32, blue: 0.56).opacity(0.55)
    static let pageBottomGlow = Color(red: 0.07, green: 0.10, blue: 0.17)

    static let cardBackground = Color.white.opacity(0.08)
    static let cardBorder = Color.white.opacity(0.16)
    static let cardShadow = Color.black.opacity(0.35)

    static let accent = Color(red: 0.22, green: 0.64, blue: 1.0)
    static let accentSecondary = Color(red: 0.38, green: 0.88, blue: 0.73)
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.72)
}

enum AppTypography {
    static let hero = Font.system(size: 30, weight: .bold, design: .rounded)
    static let title = Font.system(.title3, design: .rounded).weight(.semibold)
    static let subtitle = Font.system(.headline, design: .rounded).weight(.semibold)
    static let body = Font.system(.subheadline, design: .rounded)
    static let caption = Font.system(.footnote, design: .rounded)
}

enum AppShadow {
    static let cardRadius: CGFloat = 20
    static let cardY: CGFloat = 10
}

enum AppAnimation {
    static let smoothSpring = Animation.spring(response: 0.48, dampingFraction: 0.86, blendDuration: 0.1)
}

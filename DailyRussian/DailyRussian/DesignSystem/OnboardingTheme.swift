import SwiftUI

enum OnboardingTheme {
    static let background = Color.black
    static let cardBackground = Color(red: 0.11, green: 0.11, blue: 0.12)

    /// Primary brand red — visible on black, similar weight to the former purple accent.
    static let accent = Color(red: 0.91, green: 0.35, blue: 0.37)

    /// Slightly softer red for large gradient fills.
    static let accentSoft = Color(red: 0.86, green: 0.38, blue: 0.40)

    /// Dark burgundy track behind the progress bar fill.
    static let progressTrack = Color(red: 0.32, green: 0.11, blue: 0.13)

    /// Hero card halo — bright → deep red (replaces blue / purple / cyan glow).
    static let glowBright = Color(red: 0.94, green: 0.36, blue: 0.38)
    static let glowMid = Color(red: 0.82, green: 0.26, blue: 0.28)
    static let glowWarm = Color(red: 0.90, green: 0.42, blue: 0.30)

    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.56, green: 0.56, blue: 0.58)
    static let checkGreen = Color(red: 0.2, green: 0.78, blue: 0.35)

    static let facebookBlue = Color(red: 0.09, green: 0.47, blue: 0.95)
    static let redditOrange = Color(red: 1.0, green: 0.27, blue: 0.05)
    static let chatGPTGreen = Color(red: 0.07, green: 0.64, blue: 0.50)

    static var instagramGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.98, green: 0.75, blue: 0.30),
                Color(red: 0.89, green: 0.28, blue: 0.22),
                Color(red: 0.55, green: 0.22, blue: 0.72),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static let horizontalPadding: CGFloat = 20
    static let rowCornerRadius: CGFloat = 14
    static let rowSpacing: CGFloat = 10

    /// Radial gradient used behind landing hero cards.
    static var heroHaloGradient: RadialGradient {
        RadialGradient(
            colors: [
                glowBright.opacity(0.6),
                accent.opacity(0.45),
                glowWarm.opacity(0.28),
                Color.clear,
            ],
            center: .center,
            startRadius: 4,
            endRadius: 90
        )
    }

}

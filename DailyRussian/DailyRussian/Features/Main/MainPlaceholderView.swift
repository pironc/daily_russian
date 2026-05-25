import SwiftUI

struct MainPlaceholderView: View {
    let profile: OnboardingProfile?
    var onResetOnboarding: (() -> Void)?

    var body: some View {
        ZStack {
            OnboardingTheme.background.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Daily Russian")
                    .font(.largeTitle.bold())
                    .foregroundStyle(OnboardingTheme.primaryText)

                Text("You're all set!")
                    .font(.title3)
                    .foregroundStyle(OnboardingTheme.secondaryText)

                if let profile, let goal = profile.dailyGoal {
                    Text("Daily goal: \(OnboardingContent.dailyGoalLabel(goal))")
                        .font(.subheadline)
                        .foregroundStyle(OnboardingTheme.accent)
                }

                Text("Main lessons and practice screens will live here.")
                    .font(.footnote)
                    .foregroundStyle(OnboardingTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                if let onResetOnboarding {
                    Button("Reset onboarding (debug)", action: onResetOnboarding)
                        .font(.caption)
                        .foregroundStyle(OnboardingTheme.secondaryText)
                        .padding(.top, 24)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

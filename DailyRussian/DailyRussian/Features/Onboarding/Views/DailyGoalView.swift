import SwiftUI

struct DailyGoalView: View {
    @Bindable var store: OnboardingStore
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            OnboardingChrome(
                progress: OnboardingStep.dailyGoal.progress,
                title: "What's your daily studying goal?",
                onBack: { store.goBack() }
            ) {
                Spacer(minLength: 0)
            }

            VStack(spacing: OnboardingTheme.rowSpacing) {
                ForEach(DailyGoal.allCases) { goal in
                    SelectionRow(
                        emoji: OnboardingContent.dailyGoalEmoji(goal),
                        title: OnboardingContent.dailyGoalLabel(goal)
                    ) {
                        _ = store.completeDailyGoal(goal)
                        onComplete()
                    }
                }
            }
            .padding(.horizontal, OnboardingTheme.horizontalPadding)
            .padding(.bottom, 32)
        }
        .background(OnboardingTheme.background)
        .preferredColorScheme(.dark)
    }
}

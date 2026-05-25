import SwiftUI

struct DailyGoalView: View {
    @Bindable var store: OnboardingStore
    let onComplete: () -> Void

    var body: some View {
        OnboardingChrome(
            progress: OnboardingStep.dailyGoal.progress,
            title: "What's your daily studying goal?",
            onBack: { store.goBack() }
        ) {
            BottomAlignedOptionsScrollView {
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
            }
        }
        .preferredColorScheme(.dark)
    }
}

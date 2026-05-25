import SwiftUI

struct WhatBringsYouView: View {
    @Bindable var store: OnboardingStore

    private var goals: [PrimaryGoal] {
        guard let persona = store.profile.persona else { return [] }
        return OnboardingContent.primaryGoals(for: persona)
    }

    var body: some View {
        OnboardingChrome(
            progress: OnboardingStep.whatBringsYou.progress,
            title: "What brings you to Daily Russian?",
            onBack: { store.goBack() }
        ) {
            ScrollView {
                VStack(spacing: OnboardingTheme.rowSpacing) {
                    ForEach(goals) { goal in
                        SelectionRow(
                            emoji: OnboardingContent.primaryGoalEmoji(goal),
                            title: OnboardingContent.primaryGoalLabel(goal)
                        ) {
                            store.selectPrimaryGoal(goal)
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(.dark)
    }
}

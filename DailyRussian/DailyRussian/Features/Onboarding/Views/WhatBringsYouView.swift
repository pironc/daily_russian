import SwiftUI

struct WhatBringsYouView: View {
    @Bindable var store: OnboardingStore

    private var goals: [PrimaryGoal] {
        guard let persona = store.profile.persona else { return [] }
        return OnboardingContent.primaryGoals(for: persona)
    }

    var body: some View {
        VStack(spacing: 0) {
            OnboardingChrome(
                progress: OnboardingStep.whatBringsYou.progress,
                title: "What brings you to Daily Russian?",
                onBack: { store.goBack() }
            ) {
                BottomAlignedOptionsScrollView {
                    VStack(spacing: OnboardingTheme.rowSpacing) {
                        ForEach(goals) { goal in
                            SelectionRow(
                                emoji: OnboardingContent.primaryGoalEmoji(goal),
                                title: OnboardingContent.primaryGoalLabel(goal),
                                isSelected: store.profile.primaryGoals.contains(goal)
                            ) {
                                store.togglePrimaryGoal(goal)
                            }
                        }
                    }
                }
            }

            HStack {
                Spacer()
                SolidCompactContinueButton {
                    store.advanceFromWhatBringsYou()
                }
                .opacity(store.profile.primaryGoals.isEmpty ? 0.4 : 1)
                .disabled(store.profile.primaryGoals.isEmpty)
                .padding(.trailing, OnboardingTheme.horizontalPadding)
                .padding(.bottom, 24)
            }
        }
        .background(OnboardingTheme.background)
        .preferredColorScheme(.dark)
    }
}

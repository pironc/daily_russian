import SwiftUI

struct OnboardingCoordinatorView: View {
    @Bindable var store: OnboardingStore
    let onExitToLanding: () -> Void
    let onComplete: () -> Void

    private var allowsBackNavigation: Bool {
        store.canGoBack || store.currentStep == .referral
    }

    var body: some View {
        Group {
            switch store.currentStep {
            case .referral:
                ReferralSourceView(store: store, onBack: onExitToLanding)
            case .persona:
                PersonaView(store: store)
            case .workField:
                WorkFieldView(store: store)
            case .whatBringsYou:
                WhatBringsYouView(store: store)
            case .testimonial:
                TestimonialView(store: store)
            case .featureGrid:
                FeatureGridView(store: store)
            case .classExam:
                ClassExamView(store: store)
            case .dailyGoal:
                DailyGoalView(store: store, onComplete: onComplete)
            }
        }
        .onboardingSwipeBack(isEnabled: allowsBackNavigation) {
            navigateBack()
        }
        .animation(.easeInOut(duration: 0.25), value: store.currentStep)
        .frame(maxWidth: 500)
        .frame(maxWidth: .infinity)
    }

    private func navigateBack() {
        if store.canGoBack {
            store.goBack()
        } else if store.currentStep == .referral {
            onExitToLanding()
        }
    }
}

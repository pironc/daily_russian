import SwiftUI

struct ReferralSourceView: View {
    @Bindable var store: OnboardingStore
    let onBack: () -> Void

    private let displayedReferralSources: [ReferralSource] = [
        .instagramReels,
        .tiktok,
        .facebook,
        .appStore,
        .reddit,
        // .chatGPT,
        .friendsFamily,
        .other,
    ]

    var body: some View {
        OnboardingChrome(
            progress: OnboardingStep.referral.progress,
            title: "How did you hear about Daily Russian?",
            onBack: onBack
        ) {
            ScrollView {
                VStack(spacing: OnboardingTheme.rowSpacing) {
                    ForEach(displayedReferralSources) { source in
                        SelectionRow(
                            icon: { ReferralSourceIcon(source: source) },
                            title: OnboardingContent.referralLabel(source)
                        ) {
                            store.selectReferral(source)
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

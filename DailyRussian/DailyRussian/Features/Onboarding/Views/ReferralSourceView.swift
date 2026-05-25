import SwiftUI

struct ReferralSourceView: View {
    @Bindable var store: OnboardingStore
    let onBack: () -> Void

    var body: some View {
        OnboardingChrome(
            progress: OnboardingStep.referral.progress,
            title: "How did you hear about Daily Russian?",
            onBack: onBack
        ) {
            ScrollView {
                VStack(spacing: OnboardingTheme.rowSpacing) {
                    ForEach(ReferralSource.allCases) { source in
                        SelectionRow(
                            systemImage: OnboardingContent.referralSymbol(source),
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

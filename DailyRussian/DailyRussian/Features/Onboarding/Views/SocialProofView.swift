import SwiftUI

struct SocialProofView: View {
    @Bindable var store: OnboardingStore

    private var field: WorkField {
        store.profile.workField ?? .finance
    }

    var body: some View {
        VStack(spacing: 0) {
            OnboardingChrome(
                progress: OnboardingStep.socialProof.progress,
                title: "You're in good company!",
                onBack: { store.goBack() }
            ) {
                VStack(spacing: 20) {
                    socialProofText
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(OnboardingContent.socialProofBullets(for: field), id: \.self) { bullet in
                            ChecklistRow(text: bullet)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                    Spacer(minLength: 40)
                }
            }

            HStack {
                Spacer()
                SolidCompactContinueButton {
                    store.advanceFromSocialProof()
                }
                .padding(.trailing, OnboardingTheme.horizontalPadding)
                .padding(.bottom, 24)
            }
        }
        .background(OnboardingTheme.background)
        .preferredColorScheme(.dark)
    }

    private var socialProofText: some View {
        let highlightedRole = Text(OnboardingContent.workFieldRoleHighlight(field))
            .foregroundStyle(OnboardingTheme.accent)
            .bold()

        return Text("We have thousands of \(highlightedRole) learning with Daily Russian to:")
            .foregroundStyle(OnboardingTheme.primaryText)
            .font(.body)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}

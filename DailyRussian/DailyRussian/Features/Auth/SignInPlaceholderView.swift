import SwiftUI

struct SignInPlaceholderView: View {
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            OnboardingTheme.background.ignoresSafeArea()
            VStack(spacing: 24) {
                Text("Sign in")
                    .font(.title.bold())
                    .foregroundStyle(OnboardingTheme.primaryText)

                Text("Sign in with Apple and email will be added after onboarding is complete.")
                    .font(.body)
                    .foregroundStyle(OnboardingTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                PrimaryContinueButton(title: "Back", trailing: "←", action: onDismiss)
                    .padding(.horizontal, OnboardingTheme.horizontalPadding)
            }
        }
        .preferredColorScheme(.dark)
    }
}

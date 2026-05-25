import SwiftUI

struct PersonaView: View {
    @Bindable var store: OnboardingStore

    var body: some View {
        OnboardingChrome(
            progress: OnboardingStep.persona.progress,
            title: "Which best describes you?",
            onBack: { store.goBack() }
        ) {
            ScrollView {
                VStack(spacing: OnboardingTheme.rowSpacing) {
                    ForEach(UserPersona.allCases) { persona in
                        SelectionRow(
                            emoji: OnboardingContent.personaEmoji(persona),
                            title: OnboardingContent.personaTitle(persona),
                            subtitle: OnboardingContent.personaSubtitle(persona)
                        ) {
                            store.selectPersona(persona)
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

import SwiftUI

struct PersonaView: View {
    @Bindable var store: OnboardingStore

    private let displayedPersonas: [UserPersona] = [
        .workingProfessional,
        .student,
        .parent,
        .teacher,
    ]

    var body: some View {
        OnboardingChrome(
            progress: OnboardingStep.persona.progress,
            title: "Which best describes you?",
            onBack: { store.goBack() }
        ) {
            BottomAlignedOptionsScrollView {
                VStack(spacing: OnboardingTheme.rowSpacing) {
                    ForEach(displayedPersonas) { persona in
                        SelectionRow(
                            emoji: OnboardingContent.personaEmoji(persona),
                            title: OnboardingContent.personaTitle(persona),
                            subtitle: OnboardingContent.personaSubtitle(persona)
                        ) {
                            store.selectPersona(persona)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

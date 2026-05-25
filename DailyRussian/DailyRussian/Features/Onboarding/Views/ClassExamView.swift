import SwiftUI

struct ClassExamView: View {
    @Bindable var store: OnboardingStore

    var body: some View {
        VStack(spacing: 0) {
            OnboardingChrome(
                progress: OnboardingStep.classExam.progress,
                title: "Do you have a specific class or exam in mind for Daily Russian to help with?",
                onBack: { store.goBack() }
            ) {
                Spacer(minLength: 0)
            }

            VStack(spacing: OnboardingTheme.rowSpacing) {
                ForEach(StudyFocus.allCases) { focus in
                    SelectionRow(
                        emoji: OnboardingContent.studyFocusEmoji(focus),
                        title: OnboardingContent.studyFocusLabel(focus)
                    ) {
                        store.selectStudyFocus(focus)
                    }
                }
            }
            .padding(.horizontal, OnboardingTheme.horizontalPadding)
            .padding(.bottom, 32)
        }
        .background(OnboardingTheme.background)
        .preferredColorScheme(.dark)
    }
}

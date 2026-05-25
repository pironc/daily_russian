import SwiftUI

struct ClassExamView: View {
    @Bindable var store: OnboardingStore
    @State private var isShowingOtherPrompt = false
    @State private var otherStudyFocusDraft = ""

    var body: some View {
        OnboardingChrome(
            progress: OnboardingStep.classExam.progress,
            title: "Do you have a specific class or exam in mind for Daily Russian to help with?",
            onBack: { store.goBack() }
        ) {
            BottomAlignedOptionsScrollView {
                VStack(spacing: OnboardingTheme.rowSpacing) {
                    ForEach(StudyFocus.allCases) { focus in
                        SelectionRow(
                            emoji: OnboardingContent.studyFocusEmoji(focus),
                            title: OnboardingContent.studyFocusLabel(focus),
                            isSelected: isSelected(focus)
                        ) {
                            select(focus)
                        }
                    }
                }
            }
        }
        .alert("Something else", isPresented: $isShowingOtherPrompt) {
            TextField("Tell us what you have in mind", text: $otherStudyFocusDraft)
                .textInputAutocapitalization(.sentences)

            Button("Continue") {
                store.completeStudyFocusCustomSelection(otherStudyFocusDraft)
            }
            .disabled(OnboardingInputSanitizer.sanitizeFreeform(otherStudyFocusDraft).isEmpty)

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Describe the class, exam, or goal you want help with.")
        }
        .preferredColorScheme(.dark)
    }

    private func select(_ focus: StudyFocus) {
        if focus == .somethingElse {
            otherStudyFocusDraft = store.profile.studyFocus?.custom == true ? store.profile.studyFocus?.value ?? "" : ""
            store.selectStudyFocus(focus)
            isShowingOtherPrompt = true
        } else {
            store.selectStudyFocus(focus)
        }
    }

    private func isSelected(_ focus: StudyFocus) -> Bool {
        if focus == .somethingElse {
            return store.profile.studyFocus?.custom == true
        }

        return store.profile.studyFocus?.value == focus.selectionID
            && store.profile.studyFocus?.custom != true
    }
}

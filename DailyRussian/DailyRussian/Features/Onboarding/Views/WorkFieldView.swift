import SwiftUI

struct WorkFieldView: View {
    @Bindable var store: OnboardingStore

    var body: some View {
        OnboardingChrome(
            progress: OnboardingStep.workField.progress,
            title: "Which best describes your work?",
            onBack: { store.goBack() }
        ) {
            ScrollView {
                VStack(spacing: OnboardingTheme.rowSpacing) {
                    ForEach(WorkField.allCases) { field in
                        SelectionRow(
                            emoji: OnboardingContent.workFieldEmoji(field),
                            title: OnboardingContent.workFieldLabel(field)
                        ) {
                            store.selectWorkField(field)
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

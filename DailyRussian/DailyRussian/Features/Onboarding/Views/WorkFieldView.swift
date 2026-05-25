import SwiftUI

struct WorkFieldView: View {
    @Bindable var store: OnboardingStore

    var body: some View {
        OnboardingChrome(
            progress: OnboardingStep.workField.progress,
            title: "Which best describes your work?",
            onBack: { store.goBack() }
        ) {
            BottomAlignedOptionsScrollView {
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
            }
        }
        .preferredColorScheme(.dark)
    }
}

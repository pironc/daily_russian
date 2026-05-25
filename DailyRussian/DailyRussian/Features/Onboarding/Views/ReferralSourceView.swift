import SwiftUI

struct ReferralSourceView: View {
    @Bindable var store: OnboardingStore
    let onBack: () -> Void
    @State private var isShowingOtherPrompt = false
    @State private var otherReferralDraft = ""

    private let displayedReferralSources: [ReferralSource] = [
        .instagram,
        .tiktok,
        .facebook,
        .appStore,
        .reddit,
        // .chatGPT,
        .friendsAndFamily,
        .other,
    ]

    var body: some View {
        OnboardingChrome(
            progress: OnboardingStep.referral.progress,
            title: "How did you hear about Daily Russian?",
            onBack: onBack
        ) {
            BottomAlignedOptionsScrollView {
                VStack(spacing: OnboardingTheme.rowSpacing) {
                    ForEach(displayedReferralSources) { source in
                        SelectionRow(
                            icon: { ReferralSourceIcon(source: source) },
                            title: OnboardingContent.referralLabel(source),
                            isSelected: isSelected(source)
                        ) {
                            select(source)
                        }
                    }
                }
            }
        }
        .alert("Other", isPresented: $isShowingOtherPrompt) {
            TextField("Where did you hear about us?", text: $otherReferralDraft)
                .textInputAutocapitalization(.sentences)

            Button("Continue") {
                store.completeReferralCustomSelection(otherReferralDraft)
            }
            .disabled(OnboardingInputSanitizer.sanitizeFreeform(otherReferralDraft).isEmpty)

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Tell us where you heard about Daily Russian.")
        }
        .preferredColorScheme(.dark)
    }

    private func select(_ source: ReferralSource) {
        if source == .other {
            otherReferralDraft = store.profile.referralSource?.custom == true ? store.profile.referralSource?.value ?? "" : ""
            store.selectReferral(source)
            isShowingOtherPrompt = true
        } else {
            store.selectReferral(source)
        }
    }

    private func isSelected(_ source: ReferralSource) -> Bool {
        if source == .other {
            return store.profile.referralSource?.custom == true
        }

        return store.profile.referralSource?.value == source.selectionID
            && store.profile.referralSource?.custom != true
    }
}

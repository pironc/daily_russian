import SwiftUI

struct FeatureGridView: View {
    @Bindable var store: OnboardingStore

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        VStack(spacing: 0) {
            OnboardingChrome(
                progress: OnboardingStep.featureGrid.progress,
                title: "Which part of Daily Russian will help you most?",
                onBack: { store.goBack() }
            ) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(TopFeature.allCases) { feature in
                        featureCell(feature)
                    }
                }
                .padding(.top, 8)

                Spacer(minLength: 40)
            }

            HStack {
                Spacer()
                SolidCompactContinueButton {
                    store.advanceFromFeatureGrid()
                }
                .opacity(store.profile.topFeature == nil ? 0.4 : 1)
                .disabled(store.profile.topFeature == nil)
                .padding(.trailing, OnboardingTheme.horizontalPadding)
                .padding(.bottom, 24)
            }
        }
        .background(OnboardingTheme.background)
        .preferredColorScheme(.dark)
    }

    private func featureCell(_ feature: TopFeature) -> some View {
        let selected = store.profile.topFeature == feature
        return Button {
            store.selectTopFeature(feature)
        } label: {
            VStack(spacing: 12) {
                Image(systemName: OnboardingContent.featureIcon(feature))
                    .font(.system(size: 36))
                    .foregroundStyle(selected ? OnboardingTheme.accent : OnboardingTheme.primaryText)
                    .frame(height: 56)

                Text(OnboardingContent.featureTitle(feature))
                    .font(.caption.weight(.medium))
                    .foregroundStyle(selected ? OnboardingTheme.accent : OnboardingTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(OnboardingTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selected ? OnboardingTheme.accent : Color.clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

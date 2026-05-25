import SwiftUI

struct OnboardingChrome<Content: View>: View {
    let progress: Double
    let title: String
    /// When set, shows the top-leading back chevron (use only when `canGoBack` is true).
    var onBack: (() -> Void)?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                if let onBack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(OnboardingTheme.primaryText)
                            .frame(width: 44, height: 44)
                    }
                } else {
                    Color.clear.frame(width: 44, height: 44)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(OnboardingTheme.progressTrack)
                        Capsule()
                            .fill(OnboardingTheme.accent)
                            .frame(width: max(8, geo.size.width * progress))
                    }
                }
                .frame(height: 6)
            }

            Text(OnboardingContent.personalizeSubtitle)
                .font(.footnote)
                .foregroundStyle(OnboardingTheme.accent)

            Text(title)
                .font(.title2.bold())
                .foregroundStyle(OnboardingTheme.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            content()
        }
        .padding(.horizontal, OnboardingTheme.horizontalPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(OnboardingTheme.background)
    }
}

struct BottomAlignedOptionsScrollView<Content: View>: View {
    var bottomPadding: CGFloat = 32
    @ViewBuilder let content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)

                    content()
                        .padding(.bottom, bottomPadding)
                }
                .frame(minHeight: proxy.size.height, alignment: .bottom)
            }
        }
    }
}

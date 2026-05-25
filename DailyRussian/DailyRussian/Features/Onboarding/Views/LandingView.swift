import SwiftUI

struct LandingView: View {
    let onContinue: () -> Void
    let onSignIn: () -> Void

    private let features = ["Vocabulary", "Grammar", "Speaking", "Listening"]

    var body: some View {
        ZStack {
            OnboardingTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                heroCarousel
                    .padding(.top, 24)

                Text("Build Russian habit by habit")
                    .font(.title.bold())
                    .foregroundStyle(OnboardingTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 28)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(features, id: \.self) { feature in
                            FeatureChip(label: feature)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 16)

                Spacer(minLength: 16)

                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Start free today")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(OnboardingTheme.accent)
                        Image(systemName: "arrow.turn.right.down")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(OnboardingTheme.accent)
                    }

                    PrimaryContinueButton(trailing: "👉", action: onContinue)
                        .padding(.horizontal, OnboardingTheme.horizontalPadding)

                    Button(action: onSignIn) {
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundStyle(OnboardingTheme.secondaryText)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var heroCarousel: some View {
        ZStack {
            sideCard {
                VStack(spacing: 4) {
                    Text("4.9")
                        .font(.title2.bold())
                        .foregroundStyle(.black)
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                        }
                    }
                    Text("App Store rating")
                        .font(.caption2)
                        .foregroundStyle(.black.opacity(0.7))
                }
            }
            .offset(x: -100)
            .scaleEffect(0.88)

            sideCard {
                VStack(spacing: 6) {
                    Image(systemName: "trophy.fill")
                        .font(.title)
                        .foregroundStyle(OnboardingTheme.accent)
                    Text("Built for daily practice")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(OnboardingTheme.accent)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 8)
            }
            .offset(x: 100)
            .scaleEffect(0.88)

            centerCard
        }
        .frame(height: 200)
    }

    private var centerCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    RadialGradient(
                        colors: [
                            OnboardingTheme.accent.opacity(0.5),
                            Color.cyan.opacity(0.2),
                            Color.clear,
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 120
                    )
                )
                .frame(width: 200, height: 200)
                .blur(radius: 20)

            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .frame(width: 140, height: 160)
                .shadow(color: .white.opacity(0.2), radius: 20)

            Text("🇷🇺")
                .font(.system(size: 64))
        }
    }

    private func sideCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .frame(width: 120, height: 130)
            .overlay { content() }
            .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
    }
}

#Preview {
    LandingView(onContinue: {}, onSignIn: {})
}

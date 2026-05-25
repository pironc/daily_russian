import SwiftUI
import UIKit

struct LandingView: View {
    let onContinue: () -> Void
    let onSignIn: () -> Void

    private let featureMarqueeItems = ["Vocabulary", "Grammar", "Speaking", "Listening", "Daily words"]
    private let sideCardSize: CGFloat = 110
    private let centerCardSize: CGFloat = 132
    private let heroCardCornerRadius: CGFloat = 18

    var body: some View {
        ZStack {
            OnboardingTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                heroCarousel
                    .padding(.top, 40)

                headline
                    .padding(.horizontal, 24)
                    .padding(.top, 28)

                FeatureMarqueeRow(items: featureMarqueeItems)
                    .frame(height: 34)
                    .padding(.top, 16)

                Spacer(minLength: 16)

                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Try for free today")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(OnboardingTheme.accent)
                        Image(systemName: "arrow.turn.right.down")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(OnboardingTheme.accent)
                    }

                    LandingContinueButton(action: onContinue)
                        .padding(.horizontal, OnboardingTheme.horizontalPadding)

                    Button(action: onSignIn) {
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundStyle(OnboardingTheme.secondaryText)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var headline: some View {
        VStack(spacing: 6) {
            Text("Russian practice\nthat actually sticks")
                .font(.title.bold())
                .foregroundStyle(OnboardingTheme.primaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
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
                    Text("App Store")
                        .font(.caption2)
                        .foregroundStyle(.black.opacity(0.7))
                }
            }
            .offset(x: -100)
            .scaleEffect(0.88)
            .zIndex(0)

            sideCard {
                VStack(spacing: 6) {
                    Image(systemName: "trophy.fill")
                        .font(.title)
                        .foregroundStyle(OnboardingTheme.accent)
                    Text("Built for\nresults")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(OnboardingTheme.accent)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 8)
            }
            .offset(x: 100)
            .scaleEffect(0.88)
            .zIndex(0)

            centerCard
                .offset(y: -6)
                .zIndex(1)
        }
        .frame(height: 180)
    }

    private var centerCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: heroCardCornerRadius)
                .fill(OnboardingTheme.accent.opacity(0.22))
                .frame(width: centerCardSize + 20, height: centerCardSize + 20)
                .blur(radius: 18)

            RoundedRectangle(cornerRadius: heroCardCornerRadius)
                .fill(Color.white)
                .frame(width: centerCardSize, height: centerCardSize)
                .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
                .overlay {
                    Text("🇷🇺")
                        .font(.system(size: 64))
                }
        }
    }

    private func sideCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: heroCardCornerRadius)
                .fill(OnboardingTheme.heroHaloGradient)
                .frame(width: sideCardSize + 28, height: sideCardSize + 28)
                .blur(radius: 20)

            RoundedRectangle(cornerRadius: heroCardCornerRadius)
                .fill(Color.white)
                .frame(width: sideCardSize, height: sideCardSize)
                .shadow(color: OnboardingTheme.accent.opacity(0.3), radius: 14)
                .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
                .overlay { content() }
        }
    }
}

#Preview {
    LandingView(onContinue: {}, onSignIn: {})
}

private struct FeatureMarqueeRow: View {
    let items: [String]

    var body: some View {
        UIKitMarqueeText(text: marqueeText)
            .frame(maxWidth: .infinity)
            .clipped()
    }

    private var marqueeText: String {
        items.joined(separator: " • ") + " • "
    }
}

private struct UIKitMarqueeText: UIViewRepresentable {
    let text: String

    func makeUIView(context: Context) -> MarqueeTextUIView {
        let view = MarqueeTextUIView()
        view.configure(text: text)
        return view
    }

    func updateUIView(_ uiView: MarqueeTextUIView, context: Context) {
        uiView.configure(text: text)
    }
}

private final class MarqueeTextUIView: UIView {
    private let labelA = UILabel()
    private let labelB = UILabel()
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var segmentWidth: CGFloat = 0
    private var currentOffset: CGFloat = 0
    private var currentText = ""

    private let scrollSpeed: CGFloat = 42
    private let textColor = UIColor(white: 0.62, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isUserInteractionEnabled = false

        [labelA, labelB].forEach { label in
            label.font = .preferredFont(forTextStyle: .title3)
            label.textColor = textColor
            label.numberOfLines = 1
            label.lineBreakMode = .byClipping
            addSubview(label)
        }
    }

    required init?(coder: NSCoder) {
        nil
    }

    func configure(text: String) {
        guard currentText != text else { return }
        currentText = text
        updateLabels(for: bounds.width)
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLabels(for: bounds.width)

        labelA.frame = CGRect(x: currentOffset, y: 0, width: segmentWidth, height: bounds.height)
        labelB.frame = CGRect(x: currentOffset + segmentWidth, y: 0, width: segmentWidth, height: bounds.height)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        window == nil ? stopScrolling() : startScrolling()
    }

    private func updateLabels(for availableWidth: CGFloat) {
        guard !currentText.isEmpty else { return }

        var repeatedText = currentText
        labelA.text = repeatedText
        labelA.sizeToFit()

        while labelA.bounds.width < max(availableWidth * 1.4, 420) {
            repeatedText += currentText
            labelA.text = repeatedText
            labelA.sizeToFit()
        }

        labelB.text = repeatedText
        labelB.sizeToFit()
        segmentWidth = labelA.bounds.width
    }

    private func startScrolling() {
        guard displayLink == nil else { return }
        lastTimestamp = 0
        let link = CADisplayLink(target: self, selector: #selector(step))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    private func stopScrolling() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func step(_ link: CADisplayLink) {
        guard segmentWidth > 0 else { return }

        if lastTimestamp == 0 {
            lastTimestamp = link.timestamp
        }

        let delta = CGFloat(link.timestamp - lastTimestamp)
        lastTimestamp = link.timestamp
        currentOffset -= scrollSpeed * delta

        if currentOffset <= -segmentWidth {
            currentOffset += segmentWidth
        }

        setNeedsLayout()
    }

    deinit {
        stopScrolling()
    }
}

private struct LandingContinueButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text("Continue")
                    .font(.headline.weight(.bold))
                Text("👉")
                    .font(.headline)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 62)
            .background(
                Capsule()
                    .fill(Color.white)
            )
            .clipShape(Capsule())
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .mask {
            Capsule()
        }
    }
}

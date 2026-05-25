import SwiftUI

/// Brand-accurate icons for the referral source list.
struct ReferralSourceIcon: View {
    let source: ReferralSource

    private let iconSize: CGFloat = 28

    var body: some View {
        Group {
            switch source {
            case .facebook:
                facebookIcon
            case .instagram:
                instagramIcon
            case .tiktok:
                tiktokIcon
            case .chatGPT:
                openAIIcon
            case .appStore:
                Image(systemName: "apple.logo")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.white)
            case .reddit:
                redditIcon
            case .friendsAndFamily:
                Text("💬").font(.title2)
            case .other:
                Text("✍️").font(.title2)
            }
        }
        .frame(width: 36, height: 36)
    }

    private var facebookIcon: some View {
        Image("ReferralFacebook")
            .resizable()
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
    }

    private var instagramIcon: some View {
        Image("ReferralInstagram")
            .resizable()
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
    }

    private var tiktokIcon: some View {
        Image("ReferralTikTok")
            .resizable()
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
            .foregroundStyle(.white)
    }

    private var redditIcon: some View {
        Image("ReferralReddit")
            .resizable()
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
    }

    /// OpenAI mark (used for ChatGPT) in brand green on dark rows.
    private var openAIIcon: some View {
        Image("ReferralOpenAI")
            .resizable()
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
            .foregroundStyle(OnboardingTheme.chatGPTGreen)
    }
}

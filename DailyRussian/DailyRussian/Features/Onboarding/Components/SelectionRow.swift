import SwiftUI

struct SelectionRow: View {
    let emoji: String?
    let systemImage: String?
    let title: String
    var subtitle: String?
    let action: () -> Void

    init(emoji: String, title: String, subtitle: String? = nil, action: @escaping () -> Void) {
        self.emoji = emoji
        self.systemImage = nil
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }

    init(systemImage: String, title: String, subtitle: String? = nil, action: @escaping () -> Void) {
        self.emoji = nil
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                if let emoji {
                    Text(emoji)
                        .font(.title2)
                        .frame(width: 36, alignment: .center)
                } else if let systemImage {
                    Image(systemName: systemImage)
                        .font(.title3)
                        .foregroundStyle(OnboardingTheme.primaryText)
                        .frame(width: 36, alignment: .center)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(OnboardingTheme.primaryText)
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(OnboardingTheme.secondaryText)
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, subtitle == nil ? 18 : 14)
            .background(OnboardingTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: OnboardingTheme.rowCornerRadius))
        }
        .buttonStyle(.plain)
    }
}

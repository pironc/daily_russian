import SwiftUI

struct SelectionRow: View {
    private let iconBuilder: (() -> AnyView)?
    let emoji: String?
    let systemImage: String?
    let title: String
    var subtitle: String?
    var isSelected: Bool
    let action: () -> Void

    init<I: View>(icon: @escaping () -> I, title: String, subtitle: String? = nil, isSelected: Bool = false, action: @escaping () -> Void) {
        self.iconBuilder = { AnyView(icon()) }
        self.emoji = nil
        self.systemImage = nil
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.action = action
    }

    init(emoji: String, title: String, subtitle: String? = nil, isSelected: Bool = false, action: @escaping () -> Void) {
        self.iconBuilder = nil
        self.emoji = emoji
        self.systemImage = nil
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.action = action
    }

    init(systemImage: String, title: String, subtitle: String? = nil, isSelected: Bool = false, action: @escaping () -> Void) {
        self.iconBuilder = nil
        self.emoji = nil
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                if let iconBuilder {
                    iconBuilder()
                } else if let emoji {
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
                        .font(.callout.weight(.medium))
                        .foregroundStyle(OnboardingTheme.primaryText)
                    if let subtitle {
                        Text(subtitle)
                            .font(.footnote)
                            .foregroundStyle(OnboardingTheme.secondaryText)
                    }
                }
                Spacer(minLength: 0)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(OnboardingTheme.accent)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, subtitle == nil ? 18 : 14)
            .background(OnboardingTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: OnboardingTheme.rowCornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: OnboardingTheme.rowCornerRadius)
                    .stroke(isSelected ? OnboardingTheme.accent : Color.clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

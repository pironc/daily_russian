import SwiftUI

struct PrimaryContinueButton: View {
    var title: String = "Continue"
    var trailing: String = "👉"
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.headline.weight(.bold))
                Text(trailing)
                    .font(.headline)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background {
                Capsule()
                    .fill(Color.white)
            }
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct CompactContinueButton: View {
    var enabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text("Continue")
                    .font(.headline.weight(.semibold))
                Text("→")
                    .font(.headline.weight(.semibold))
            }
            .foregroundStyle(enabled ? OnboardingTheme.primaryText : OnboardingTheme.secondaryText)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .overlay {
                Capsule()
                    .stroke(enabled ? Color.white.opacity(0.8) : Color.white.opacity(0.25), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}

struct SolidCompactContinueButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text("Continue")
                    .font(.headline.weight(.bold))
                Text("→")
                    .font(.headline.weight(.bold))
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background {
                Capsule()
                    .fill(Color.white)
            }
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct ChecklistRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark")
                .font(.caption.weight(.bold))
                .foregroundStyle(OnboardingTheme.checkGreen)
                .frame(width: 28, height: 28)
                .background(OnboardingTheme.cardBackground)
                .clipShape(Circle())
            Text(text)
                .font(.body)
                .foregroundStyle(OnboardingTheme.primaryText)
                .multilineTextAlignment(.leading)
        }
    }
}

import SwiftUI

/// Swipe from the leading edge toward the right to go back (same direction as the back chevron).
struct OnboardingSwipeBackModifier: ViewModifier {
    let isEnabled: Bool
    let onBack: () -> Void

    @State private var dragOffset: CGFloat = 0

    private let leadingEdgeThreshold: CGFloat = 48
    private let triggerDistance: CGFloat = 72
    private let maxDragOffset: CGFloat = 100

    func body(content: Content) -> some View {
        content
            .offset(x: isEnabled ? dragOffset : 0)
            .simultaneousGesture(isEnabled ? backDragGesture : nil)
    }

    private var backDragGesture: some Gesture {
        DragGesture(minimumDistance: 15, coordinateSpace: .local)
            .onChanged { value in
                guard value.startLocation.x <= leadingEdgeThreshold else { return }
                let horizontal = value.translation.width
                guard horizontal > 0, horizontal > abs(value.translation.height) else { return }
                dragOffset = min(horizontal * 0.35, maxDragOffset)
            }
            .onEnded { value in
                guard value.startLocation.x <= leadingEdgeThreshold else {
                    resetDragOffset()
                    return
                }
                let horizontal = value.translation.width
                let mostlyHorizontal = horizontal > abs(value.translation.height)
                if horizontal > triggerDistance, mostlyHorizontal {
                    onBack()
                }
                resetDragOffset()
            }
    }

    private func resetDragOffset() {
        withAnimation(.easeOut(duration: 0.2)) {
            dragOffset = 0
        }
    }
}

extension View {
    func onboardingSwipeBack(isEnabled: Bool, onBack: @escaping () -> Void) -> some View {
        modifier(OnboardingSwipeBackModifier(isEnabled: isEnabled, onBack: onBack))
    }
}

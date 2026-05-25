import SwiftUI

struct TestimonialView: View {
    @Bindable var store: OnboardingStore

    private var testimonial: OnboardingContent.Testimonial {
        OnboardingContent.testimonial(for: store.profile.persona ?? .student)
    }

    var body: some View {
        VStack(spacing: 0) {
            OnboardingChrome(
                progress: OnboardingStep.testimonial.progress,
                title: "You're in the right place.",
                onBack: { store.goBack() }
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(testimonial.role)
                            .font(.headline.bold())
                            .foregroundStyle(OnboardingTheme.primaryText)

                        Text(testimonial.quote)
                            .font(.body)
                            .foregroundStyle(OnboardingTheme.primaryText.opacity(0.9))
                            .fixedSize(horizontal: false, vertical: true)

                        HStack(spacing: 4) {
                            ForEach(0..<5, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(OnboardingTheme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    Spacer(minLength: 60)
                }
                .padding(.top, 8)
            }

            HStack {
                Spacer()
                SolidCompactContinueButton {
                    store.advanceFromTestimonial()
                }
                .padding(.trailing, OnboardingTheme.horizontalPadding)
                .padding(.bottom, 24)
            }
        }
        .background(OnboardingTheme.background)
        .preferredColorScheme(.dark)
    }
}

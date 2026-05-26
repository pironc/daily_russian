import AuthenticationServices
import Observation
import StoreKit
import SwiftUI

struct PostOnboardingTrialView: View {
    enum Step {
        case comparison
        case pricing
        case account
    }

    @State private var step: Step = .comparison
    @State private var subscriptionStore = TrialSubscriptionStore()

    let onComplete: () -> Void

    var body: some View {
        ZStack {
            OnboardingTheme.background.ignoresSafeArea()

            switch step {
            case .comparison:
                TrialComparisonView {
                    step = .pricing
                }
            case .pricing:
                PricingPaywallView(
                    store: subscriptionStore,
                    onBack: { step = .comparison },
                    onPurchased: { step = .account }
                )
            case .account:
                AppleAccountPromptView(
                    onComplete: onComplete,
                    onBack: { step = .pricing }
                )
            }
        }
        .preferredColorScheme(.dark)
    }
}

private struct TrialFeature: Identifiable {
    let id = UUID()
    let name: String
    let freeValue: String
    let unlimitedValue: String
}

private struct TrialComparisonView: View {
    let onContinue: () -> Void

    private let freeColumnWidth: CGFloat = 82
    private let unlimitedColumnWidth: CGFloat = 112
    private let planColumnSpacing: CGFloat = 16
    private let tableLeadingPadding: CGFloat = 18
    private let tableTrailingPadding: CGFloat = 3

    private let features: [TrialFeature] = [
        TrialFeature(name: "Daily Word", freeValue: "1", unlimitedValue: "∞"),
        TrialFeature(name: "Word history", freeValue: "7 days", unlimitedValue: "Unlimited"),
        TrialFeature(name: "Lock screen widgets", freeValue: "Basic", unlimitedValue: "All"),
        TrialFeature(name: "Vocabulary reviews", freeValue: "Limited", unlimitedValue: "Unlimited"),
        TrialFeature(name: "Grammar lessons", freeValue: "—", unlimitedValue: "✓"),
        TrialFeature(name: "Listening practice", freeValue: "—", unlimitedValue: "✓"),
        TrialFeature(name: "Smart reminders", freeValue: "—", unlimitedValue: "✓"),
    ]

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 32)

            VStack(spacing: 6) {
                Text("We want you to try")
                    .font(.largeTitle.weight(.bold))
                Text("Daily Russian for free.")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(OnboardingTheme.accent)
            }
            .foregroundStyle(OnboardingTheme.primaryText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, OnboardingTheme.horizontalPadding)

            comparisonCard
                .padding(.horizontal, OnboardingTheme.horizontalPadding)

            Spacer(minLength: 24)

            noPaymentDueNow

            PrimaryTrialButton(title: "Try for 0,00 €", action: onContinue)
                .padding(.horizontal, OnboardingTheme.horizontalPadding)

            Text("7 days free, then yearly or monthly billing")
                .font(.footnote)
                .foregroundStyle(OnboardingTheme.secondaryText)
                .padding(.bottom, 20)
        }
    }

    private var comparisonCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: planColumnSpacing) {
                Spacer()
                Text("Free")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(OnboardingTheme.secondaryText)
                    .frame(width: freeColumnWidth)
                Text("Unlimited")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(OnboardingTheme.accent)
                    .frame(width: unlimitedColumnWidth)
            }
            .padding(.leading, tableLeadingPadding)
            .padding(.trailing, tableTrailingPadding)
            .padding(.bottom, 10)

            VStack(spacing: 0) {
                ForEach(features) { feature in
                    HStack(spacing: planColumnSpacing) {
                        Text(feature.name)
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(OnboardingTheme.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        PlanValueText(feature.freeValue, isHighlighted: false)
                            .frame(width: freeColumnWidth)
                        PlanValueText(feature.unlimitedValue, isHighlighted: true)
                            .frame(width: unlimitedColumnWidth)
                    }
                    .padding(.vertical, 13)

                    if feature.id != features.last?.id {
                        Divider()
                            .overlay(Color.white.opacity(0.16))
                    }
                }
            }
            .padding(.leading, tableLeadingPadding)
            .padding(.trailing, tableTrailingPadding)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(OnboardingTheme.cardBackground)
                    .overlay(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        OnboardingTheme.progressTrack,
                                        OnboardingTheme.accent.opacity(0.55),
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: unlimitedColumnWidth)
                            .padding(3)
                    }
            }
        }
    }

    private var noPaymentDueNow: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .font(.body.weight(.bold))
            Text("No Payment Due Now")
                .font(.headline)
        }
        .foregroundStyle(OnboardingTheme.primaryText)
    }
}

private struct PlanValueText: View {
    let text: String
    let isHighlighted: Bool

    init(_ text: String, isHighlighted: Bool) {
        self.text = text
        self.isHighlighted = isHighlighted
    }

    var body: some View {
        Text(text)
            .font(.callout.weight(isHighlighted ? .bold : .semibold))
            .foregroundStyle(isHighlighted ? OnboardingTheme.primaryText : OnboardingTheme.secondaryText)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.8)
    }
}

private struct PricingPaywallView: View {
    @Bindable var store: TrialSubscriptionStore
    let onBack: () -> Void
    let onPurchased: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "xmark")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(OnboardingTheme.primaryText)
                        .frame(width: 48, height: 48)
                        .background(Color.white.opacity(0.12), in: Circle())
                }
                Spacer()
                Button("Restore") {
                    Task {
                        if await store.restorePurchases() {
                            onPurchased()
                        }
                    }
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(OnboardingTheme.secondaryText)
            }

            Spacer(minLength: 60)

            Text("🎁 Get unlimited Russian free for 7 days")
                .font(.title.weight(.bold))
                .foregroundStyle(OnboardingTheme.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer(minLength: 50)

            VStack(spacing: 14) {
                planCard(
                    title: "Yearly Plan",
                    subtitle: "7 days free, equivalent to \(store.yearlyMonthlyEquivalent)",
                    price: store.yearlyDisplayPrice,
                    isSelected: store.selectedPlan == .yearly,
                    badge: "BEST DEAL"
                ) {
                    store.selectedPlan = .yearly
                }

                planCard(
                    title: "Monthly Plan",
                    subtitle: nil,
                    price: store.monthlyDisplayPrice,
                    isSelected: store.selectedPlan == .monthly,
                    badge: nil
                ) {
                    store.selectedPlan = .monthly
                }
            }

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle")
                Text("No payment due now")
            }
            .font(.headline)
            .foregroundStyle(OnboardingTheme.primaryText)

            if let errorMessage = store.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(OnboardingTheme.accent)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            PrimaryTrialButton(title: store.isPurchasing ? "Starting..." : "Start my FREE week") {
                Task {
                    if await store.purchaseSelectedPlan() {
                        onPurchased()
                    }
                }
            }
            .disabled(store.isPurchasing)

            #if DEBUG
            Button("Continue to Apple ID (debug)") {
                onPurchased()
            }
            .font(.caption)
            .foregroundStyle(OnboardingTheme.secondaryText)
            #endif
        }
        .padding(.horizontal, OnboardingTheme.horizontalPadding)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .task {
            await store.loadProducts()
        }
    }

    private func planCard(
        title: String,
        subtitle: String?,
        price: String,
        isSelected: Bool,
        badge: String?,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                if let badge {
                    Text(badge)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(OnboardingTheme.primaryText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(OnboardingTheme.accent, in: Capsule())
                        .offset(y: -20)
                        .padding(.bottom, -18)
                }

                HStack(alignment: .firstTextBaseline) {
                    Text(title)
                        .font(.title3.weight(.bold))
                    Spacer()
                    Text(price)
                        .font(.headline.weight(.semibold))
                }

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(OnboardingTheme.primaryText.opacity(0.82))
                }
            }
            .foregroundStyle(OnboardingTheme.primaryText)
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? OnboardingTheme.progressTrack : OnboardingTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? OnboardingTheme.accent : Color.white.opacity(0.08), lineWidth: isSelected ? 2 : 1)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct AppleAccountPromptView: View {
    let onComplete: () -> Void
    let onBack: () -> Void

    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 26) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(OnboardingTheme.primaryText)
                        .frame(width: 48, height: 48)
                }
                Spacer()
            }

            Spacer()

            Text("Create your account")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(OnboardingTheme.primaryText)

            Text("Sign in with Apple so your subscription and Russian progress can be linked to your account.")
                .font(.body)
                .foregroundStyle(OnboardingTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            #if DEBUG
            Button {
                onComplete()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "apple.logo")
                        .font(.headline)
                    Text("Continue with Apple")
                        .font(.headline.weight(.semibold))
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.white, in: Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, 10)

            Text("DEBUG: simulated Apple ID. Real Sign in with Apple requires a paid Apple Developer team.")
                .font(.footnote)
                .foregroundStyle(OnboardingTheme.secondaryText)
                .multilineTextAlignment(.center)
            #else
            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success:
                    onComplete()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 56)
            .clipShape(Capsule())
            .padding(.top, 10)
            #endif

            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(OnboardingTheme.accent)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding(.horizontal, OnboardingTheme.horizontalPadding)
        .padding(.top, 12)
    }
}

private struct PrimaryTrialButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    OnboardingTheme.accent,
                                    OnboardingTheme.glowMid,
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
        }
        .buttonStyle(.plain)
    }
}

enum TrialPlan {
    case yearly
    case monthly
}

@MainActor
@Observable
final class TrialSubscriptionStore {
    private enum ProductID {
        static let yearly = "com.pironc.DailyRussian.unlimited.yearly"
        static let monthly = "com.pironc.DailyRussian.unlimited.monthly"
    }

    private enum Keys {
        static let appAccountToken = "trialAppAccountToken"
    }

    var products: [Product] = []
    var selectedPlan: TrialPlan = .yearly
    var isPurchasing = false
    var errorMessage: String?

    var yearlyDisplayPrice: String {
        guard let product = product(for: .yearly) else {
            return "69,99 € / year"
        }

        return "\(product.displayPrice) / year"
    }

    var monthlyDisplayPrice: String {
        guard let product = product(for: .monthly) else {
            return "10 € / month"
        }

        return "\(product.displayPrice) / month"
    }

    var yearlyMonthlyEquivalent: String {
        guard let product = product(for: .yearly) else {
            return "5,83 € / month"
        }

        return "\(product.displayPrice) / year"
    }

    func loadProducts() async {
        guard products.isEmpty else { return }

        do {
            products = try await Product.products(for: [ProductID.yearly, ProductID.monthly])
        } catch {
            #if DEBUG
            errorMessage = nil
            #else
            errorMessage = "Unable to load products. Check the StoreKit configuration or App Store Connect products."
            #endif
        }
    }

    func purchaseSelectedPlan() async -> Bool {
        errorMessage = nil

        guard let product = product(for: selectedPlan) else {
            #if DEBUG
            return simulateDebugPurchase()
            #else
            errorMessage = "Product unavailable. Configure StoreKit products before testing purchases."
            return false
            #endif
        }

        isPurchasing = true
        defer { isPurchasing = false }

        do {
            let result = try await product.purchase(options: [.appAccountToken(appAccountToken)])

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                return true
            case .pending:
                errorMessage = "Purchase is pending approval."
                return false
            case .userCancelled:
                return false
            @unknown default:
                errorMessage = "Purchase could not be completed."
                return false
            }
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    private func simulateDebugPurchase() -> Bool {
        errorMessage = "DEBUG: simulated purchase, no App Store charge."
        return true
    }

    func restorePurchases() async -> Bool {
        errorMessage = nil

        do {
            try await AppStore.sync()

            for await entitlement in Transaction.currentEntitlements {
                let transaction = try checkVerified(entitlement)
                if [ProductID.yearly, ProductID.monthly].contains(transaction.productID) {
                    return true
                }
            }

            errorMessage = "No active subscription found for this Apple ID."
            return false
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    private func product(for plan: TrialPlan) -> Product? {
        let productID = switch plan {
        case .yearly: ProductID.yearly
        case .monthly: ProductID.monthly
        }

        return products.first { $0.id == productID }
    }

    private var appAccountToken: UUID {
        if let tokenString = UserDefaults.standard.string(forKey: Keys.appAccountToken),
           let token = UUID(uuidString: tokenString) {
            return token
        }

        let token = UUID()
        UserDefaults.standard.set(token.uuidString, forKey: Keys.appAccountToken)
        return token
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreKitError.userCancelled
        }
    }
}

#Preview {
    PostOnboardingTrialView(onComplete: {})
}

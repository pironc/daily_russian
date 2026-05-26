import SwiftUI

struct AppRootView: View {
    @State private var appState = AppState()

    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                MainPlaceholderView(
                    profile: appState.repository.loadProfile(),
                    onResetOnboarding: {
                        appState.resetOnboarding()
                    }
                )
            } else if appState.showPostOnboardingTrial {
                PostOnboardingTrialView(
                    onComplete: { appState.completePostOnboardingSetup() }
                )
            } else if appState.showSignIn {
                SignInPlaceholderView {
                    appState.showSignIn = false
                }
            } else if appState.showOnboarding {
                OnboardingCoordinatorView(
                    store: appState.onboardingStore,
                    onExitToLanding: { appState.showOnboarding = false },
                    onComplete: { appState.finishOnboarding() }
                )
            } else {
                LandingView(
                    onContinue: { appState.showOnboarding = true },
                    onSignIn: { appState.showSignIn = true }
                )
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.hasCompletedOnboarding)
        .animation(.easeInOut(duration: 0.3), value: appState.showOnboarding)
    }
}

@Observable
final class AppState {
    let repository: UserProfileRepository
    var onboardingStore: OnboardingStore

    var hasCompletedOnboarding: Bool
    var showOnboarding = false
    var showSignIn = false
    var showPostOnboardingTrial: Bool

    init(repository: UserProfileRepository = LocalUserProfileRepository()) {
        self.repository = repository
        self.onboardingStore = OnboardingStore(repository: repository)
        self.hasCompletedOnboarding = repository.hasCompletedOnboarding
        self.showPostOnboardingTrial = !repository.hasCompletedOnboarding
            && repository.loadProfile()?.onboardingCompletedAt != nil
    }

    func finishOnboarding() {
        showOnboarding = false
        showPostOnboardingTrial = true
    }

    func completePostOnboardingSetup() {
        repository.markOnboardingCompleted()
        hasCompletedOnboarding = true
        showPostOnboardingTrial = false
        showSignIn = false
    }

    func resetOnboarding() {
        repository.clearProfile()
        onboardingStore = OnboardingStore(repository: repository)
        hasCompletedOnboarding = false
        showOnboarding = false
        showSignIn = false
        showPostOnboardingTrial = false
    }
}

#Preview {
    AppRootView()
}

import SwiftUI

struct AppRootView: View {
    @State private var appState = AppState()

    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                MainPlaceholderView(
                    profile: appState.repository.loadProfile(),
                    isShowingDictionary: appState.isShowingDictionary,
                    dictionaryWordRank: appState.dictionaryWordRank,
                    onOpenDictionary: { rank in
                        appState.openDictionary(rank: rank)
                    },
                    onCloseDictionary: {
                        appState.closeDictionary()
                    },
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
        .onOpenURL { url in
            appState.handleOpenURL(url)
        }
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
    var isShowingDictionary = false
    var dictionaryWordRank: Int?

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
        isShowingDictionary = false
        dictionaryWordRank = nil
    }

    func openDictionary(rank: Int?) {
        dictionaryWordRank = rank
        isShowingDictionary = true
    }

    func closeDictionary() {
        dictionaryWordRank = nil
        isShowingDictionary = false
    }

    func handleOpenURL(_ url: URL) {
        guard url.scheme == "dailyrussian",
              url.host == "dictionary" else {
            return
        }

        let rank = URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first { $0.name == "rank" }?
            .value
            .flatMap(Int.init)

        openDictionary(rank: rank)
    }
}

#Preview {
    AppRootView()
}

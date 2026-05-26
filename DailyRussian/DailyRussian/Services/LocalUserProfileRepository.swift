import Foundation

final class LocalUserProfileRepository: UserProfileRepository {
    private enum Keys {
        static let profile = "onboardingProfile"
        static let completed = "hasCompletedOnboarding"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var hasCompletedOnboarding: Bool {
        defaults.bool(forKey: Keys.completed)
    }

    func loadProfile() -> OnboardingProfile? {
        guard let data = defaults.data(forKey: Keys.profile) else { return nil }
        return try? JSONDecoder().decode(OnboardingProfile.self, from: data)
    }

    func saveProfile(_ profile: OnboardingProfile) {
        if let data = try? JSONEncoder().encode(profile) {
            defaults.set(data, forKey: Keys.profile)
        }
    }

    func markOnboardingCompleted() {
        defaults.set(true, forKey: Keys.completed)
    }

    func markOnboardingIncomplete() {
        defaults.set(false, forKey: Keys.completed)
    }

    func clearProfile() {
        defaults.removeObject(forKey: Keys.profile)
        defaults.set(false, forKey: Keys.completed)
    }
}

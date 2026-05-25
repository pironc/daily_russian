import Foundation

protocol UserProfileRepository {
    func loadProfile() -> OnboardingProfile?
    func saveProfile(_ profile: OnboardingProfile)
    var hasCompletedOnboarding: Bool { get }
    func markOnboardingIncomplete()
    func clearProfile()
}

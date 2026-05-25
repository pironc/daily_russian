import Foundation
import Observation

@Observable
final class OnboardingStore {
    private(set) var profile: OnboardingProfile
    private(set) var path: [OnboardingStep] = [.referral]

    private let repository: UserProfileRepository

    var currentStep: OnboardingStep {
        path.last ?? .referral
    }

    var canGoBack: Bool {
        path.count > 1
    }

    init(repository: UserProfileRepository) {
        self.repository = repository
        self.profile = repository.loadProfile() ?? OnboardingProfile()
    }

    func goBack() {
        guard path.count > 1 else { return }
        path.removeLast()
    }

    func selectReferral(_ source: ReferralSource) {
        profile.referralSource = source
        advance(from: .referral)
    }

    func selectPersona(_ persona: UserPersona) {
        profile.persona = persona
        profile.workField = nil
        profile.primaryGoal = nil
        advance(from: .persona)
    }

    func selectWorkField(_ field: WorkField) {
        profile.workField = field
        advance(from: .workField)
    }

    func advanceFromSocialProof() {
        advance(from: .socialProof)
    }

    func selectPrimaryGoal(_ goal: PrimaryGoal) {
        profile.primaryGoal = goal
        advance(from: .whatBringsYou)
    }

    func advanceFromTestimonial() {
        advance(from: .testimonial)
    }

    func selectTopFeature(_ feature: TopFeature) {
        profile.topFeature = feature
    }

    func advanceFromFeatureGrid() {
        guard profile.topFeature != nil else { return }
        advance(from: .featureGrid)
    }

    func selectStudyFocus(_ focus: StudyFocus) {
        profile.studyFocus = focus
        advance(from: .classExam)
    }

    func completeDailyGoal(_ goal: DailyGoal) -> OnboardingProfile {
        profile.dailyGoal = goal
        profile.dailyGoalMinutes = goal.minutes
        profile.onboardingCompletedAt = Date()
        profile.localeIdentifier = Locale.current.identifier
        profile.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        repository.saveProfile(profile)
        return profile
    }

    private func advance(from step: OnboardingStep) {
        guard let next = nextStep(after: step) else { return }
        if path.last == step {
            path.append(next)
        }
    }

    private func nextStep(after step: OnboardingStep) -> OnboardingStep? {
        switch step {
        case .referral:
            return .persona
        case .persona:
            if profile.persona == .workingProfessional {
                return .workField
            }
            return .whatBringsYou
        case .workField:
            return .socialProof
        case .socialProof:
            return .whatBringsYou
        case .whatBringsYou:
            return .testimonial
        case .testimonial:
            return .featureGrid
        case .featureGrid:
            if profile.persona == .teacher || profile.persona == .student {
                return .classExam
            }
            return .dailyGoal
        case .classExam:
            return .dailyGoal
        case .dailyGoal:
            return nil
        }
    }
}

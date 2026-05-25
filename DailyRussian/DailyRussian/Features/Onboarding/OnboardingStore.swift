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
        if source == .other {
            return
        }

        profile.referralSource = .preset(source.selectionID)
        debugPrintProfileChange("referral_source: \(debugAnswer(profile.referralSource))")
        advance(from: .referral)
    }

    func completeReferralCustomSelection(_ value: String) {
        let sanitizedValue = OnboardingInputSanitizer.sanitizeFreeform(value)
        guard !sanitizedValue.isEmpty else { return }

        profile.referralSource = .custom(sanitizedValue)
        debugPrintProfileChange("referral_source: \(debugAnswer(profile.referralSource))")
        advance(from: .referral)
    }

    func selectPersona(_ persona: UserPersona) {
        profile.persona = persona
        profile.workField = nil
        profile.primaryGoals = []
        debugPrintProfileChange("persona: \(persona.selectionID)")
        advance(from: .persona)
    }

    func selectWorkField(_ field: WorkField) {
        profile.workField = field
        debugPrintProfileChange("work_field: \(field.selectionID)")
        advance(from: .workField)
    }

    func togglePrimaryGoal(_ goal: PrimaryGoal) {
        toggle(goal, in: &profile.primaryGoals)
        debugPrintProfileChange("primary_goals: \(debugSelectionList(profile.primaryGoals.map(\.selectionID)))")
    }

    func advanceFromWhatBringsYou() {
        guard !profile.primaryGoals.isEmpty else { return }
        advance(from: .whatBringsYou)
    }

    func advanceFromTestimonial() {
        advance(from: .testimonial)
    }

    func toggleTopFeature(_ feature: TopFeature) {
        toggle(feature, in: &profile.topFeatures)
        debugPrintProfileChange("top_features: \(debugSelectionList(profile.topFeatures.map(\.selectionID)))")
    }

    func advanceFromFeatureGrid() {
        guard !profile.topFeatures.isEmpty else { return }
        advance(from: .featureGrid)
    }

    func selectStudyFocus(_ focus: StudyFocus) {
        if focus == .somethingElse {
            return
        }

        profile.studyFocus = .preset(focus.selectionID)
        debugPrintProfileChange("study_focus: \(debugAnswer(profile.studyFocus))")
        advance(from: .classExam)
    }

    func completeStudyFocusCustomSelection(_ value: String) {
        let sanitizedValue = OnboardingInputSanitizer.sanitizeFreeform(value)
        guard !sanitizedValue.isEmpty else { return }

        profile.studyFocus = .custom(sanitizedValue)
        debugPrintProfileChange("study_focus: \(debugAnswer(profile.studyFocus))")
        advance(from: .classExam)
    }

    func completeDailyGoal(_ goal: DailyGoal) -> OnboardingProfile {
        profile.dailyGoal = goal
        profile.onboardingCompletedAt = Date()
        profile.localeIdentifier = Locale.current.identifier
        profile.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        debugPrintProfileChange("daily_goal: \(goal.selectionID)")
        repository.saveProfile(profile)
        return profile
    }

    private func debugPrintProfileChange(_ selection: String) {
        #if DEBUG
        print("\u{001B}[2J\u{001B}[H", terminator: "")
        print("Onboarding selection")
        print(selection)
        print("")
        print("User details")
        print("referral_source: \(debugAnswer(profile.referralSource))")
        print("persona: \(profile.persona?.selectionID ?? "-")")
        print("work_field: \(profile.workField?.selectionID ?? "-")")
        print("primary_goals: \(debugSelectionList(profile.primaryGoals.map(\.selectionID)))")
        print("top_features: \(debugSelectionList(profile.topFeatures.map(\.selectionID)))")
        print("study_focus: \(debugAnswer(profile.studyFocus))")
        print("daily_goal: \(profile.dailyGoal?.selectionID ?? "-")")
        print("locale_identifier: \(profile.localeIdentifier ?? "-")")
        print("app_version: \(profile.appVersion ?? "-")")
        print("onboarding_completed_at: \(profile.onboardingCompletedAt?.description ?? "-")")
        #endif
    }

    private func toggle<T: Equatable>(_ value: T, in values: inout [T]) {
        if let index = values.firstIndex(of: value) {
            values.remove(at: index)
        } else {
            values.append(value)
        }
    }

    private func debugSelectionList(_ ids: [String]) -> String {
        "[" + ids.map { "\"\($0)\"" }.joined(separator: ", ") + "]"
    }

    private func debugAnswer(_ answer: OnboardingAnswer?) -> String {
        guard let answer else { return "-" }

        if answer.custom == true {
            return "{ value: \"\(answer.value)\", custom: true }"
        }

        return "{ value: \"\(answer.value)\" }"
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

enum OnboardingInputSanitizer {
    static func sanitizeFreeform(_ rawValue: String) -> String {
        rawValue
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            .lowercased()
    }
}

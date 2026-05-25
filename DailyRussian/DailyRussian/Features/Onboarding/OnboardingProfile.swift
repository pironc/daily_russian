import Foundation

struct OnboardingProfile: Codable, Equatable {
    var schemaVersion: Int = 1

    var referralSource: OnboardingAnswer?
    var persona: UserPersona?
    var workField: WorkField?
    var primaryGoals: [PrimaryGoal] = []
    var topFeatures: [TopFeature] = []
    var studyFocus: OnboardingAnswer?
    var dailyGoal: DailyGoal?

    var onboardingCompletedAt: Date?
    var localeIdentifier: String?
    var appVersion: String?
}

struct OnboardingAnswer: Codable, Equatable {
    let value: String
    var custom: Bool?

    static func preset(_ value: String) -> OnboardingAnswer {
        OnboardingAnswer(value: value)
    }

    static func custom(_ value: String) -> OnboardingAnswer {
        OnboardingAnswer(value: value, custom: true)
    }
}

enum ReferralSource: String, Codable, CaseIterable, Identifiable {
    case instagram, tiktok, facebook, appStore, reddit, chatGPT
    case friendsAndFamily = "friendsFamily"
    case other
    var id: String { rawValue }

    var selectionID: String {
        switch self {
        case .friendsAndFamily:
            return "friends_and_family"
        default:
            return rawValue.snakeCasedIdentifier
        }
    }
}

enum UserPersona: String, Codable, CaseIterable, Identifiable {
    case workingProfessional, student, parent, teacher, administrator
    var id: String { rawValue }
    var selectionID: String { rawValue.snakeCasedIdentifier }
}

enum WorkField: String, Codable, CaseIterable, Identifiable {
    case businessOwner, creativeMedia, education, finance, healthcare, legal
    case managerExecutive, publicService, salesMarketing
    var id: String { rawValue }
    var selectionID: String { rawValue.snakeCasedIdentifier }
}

enum PrimaryGoal: String, Codable, Identifiable {
    case conversation, travel, cultureMedia, familyFriends
    case workBusiness, schoolExam, heritage, brainTraining
    var id: String { rawValue }
    var selectionID: String { rawValue.snakeCasedIdentifier }
}

enum TopFeature: String, Codable, CaseIterable, Identifiable {
    case vocabularyDrills, listeningPractice, grammarGames, structuredCourse
    var id: String { rawValue }
    var selectionID: String { rawValue.snakeCasedIdentifier }
}

enum StudyFocus: String, Codable, CaseIterable, Identifiable {
    case specificClass, upcomingExam, somethingElse, generalHelp
    var id: String { rawValue }
    var selectionID: String { rawValue.snakeCasedIdentifier }
}

enum DailyGoal: String, Codable, CaseIterable, Identifiable {
    case casual, regular, serious, intense
    var id: String { rawValue }
    var selectionID: String { rawValue.snakeCasedIdentifier }

    var minutes: Int {
        switch self {
        case .casual: 10
        case .regular: 20
        case .serious: 60
        case .intense: 90
        }
    }
}

private extension String {
    var snakeCasedIdentifier: String {
        var previousWasLowercaseOrNumber = false

        return reduce(into: "") { result, character in
            if character.isUppercase, previousWasLowercaseOrNumber {
                result.append("_")
            }

            result.append(character.lowercased())
            previousWasLowercaseOrNumber = character.isLowercase || character.isNumber
        }
    }
}

enum OnboardingStep: Hashable {
    case referral
    case persona
    case workField
    case whatBringsYou
    case testimonial
    case featureGrid
    case classExam
    case dailyGoal

    var progress: Double {
        switch self {
        case .referral: 0.12
        case .persona: 0.20
        case .workField: 0.30
        case .whatBringsYou: 0.42
        case .testimonial: 0.54
        case .featureGrid: 0.66
        case .classExam: 0.78
        case .dailyGoal: 0.88
        }
    }
}

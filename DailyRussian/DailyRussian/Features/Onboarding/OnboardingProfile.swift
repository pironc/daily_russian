import Foundation

struct OnboardingProfile: Codable, Equatable {
    var schemaVersion: Int = 1

    var referralSource: ReferralSource?
    var persona: UserPersona?
    var workField: WorkField?
    var primaryGoal: PrimaryGoal?
    var topFeature: TopFeature?
    var studyFocus: StudyFocus?
    var dailyGoal: DailyGoal?
    var dailyGoalMinutes: Int?

    var onboardingCompletedAt: Date?
    var localeIdentifier: String?
    var appVersion: String?
}

enum ReferralSource: String, Codable, CaseIterable, Identifiable {
    case instagramReels, tiktok, facebook, appStore, reddit, chatGPT, friendsFamily, other
    var id: String { rawValue }
}

enum UserPersona: String, Codable, CaseIterable, Identifiable {
    case workingProfessional, student, parent, teacher, administrator
    var id: String { rawValue }
}

enum WorkField: String, Codable, CaseIterable, Identifiable {
    case businessOwner, creativeMedia, education, finance, healthcare, legal
    case managerExecutive, publicService, salesMarketing
    var id: String { rawValue }
}

enum PrimaryGoal: String, Codable, Identifiable {
    case focusMeetingsCalls, notesTakenForMe, summarizeDocs, learnFaster, somethingElse
    case captureClassNotes, aiPracticeTests, meetingNotes, testingForStudents
    case passExam, dailyConversation, grammarFoundations, immersionContent
    case helpChildHomework, kidExamPrep, learnTogether
    case pilotProgram, teacherTools, districtEvaluation
    var id: String { rawValue }
}

enum TopFeature: String, Codable, CaseIterable, Identifiable {
    case vocabularyDrills, listeningPractice, grammarGames, structuredCourse
    var id: String { rawValue }
}

enum StudyFocus: String, Codable, CaseIterable, Identifiable {
    case specificClass, upcomingExam, somethingElse, generalHelp
    var id: String { rawValue }
}

enum DailyGoal: String, Codable, CaseIterable, Identifiable {
    case casual, regular, serious, intense
    var id: String { rawValue }

    var minutes: Int {
        switch self {
        case .casual: 10
        case .regular: 20
        case .serious: 60
        case .intense: 90
        }
    }
}

enum OnboardingStep: Hashable {
    case referral
    case persona
    case workField
    case socialProof
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
        case .socialProof: 0.38
        case .whatBringsYou: 0.48
        case .testimonial: 0.55
        case .featureGrid: 0.65
        case .classExam: 0.75
        case .dailyGoal: 0.85
        }
    }
}

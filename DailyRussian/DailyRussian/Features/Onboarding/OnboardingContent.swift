import Foundation

enum OnboardingContent {
    static let personalizeSubtitle = "Personalizing your Daily Russian..."

    // MARK: - Referral

    static func referralLabel(_ source: ReferralSource) -> String {
        switch source {
        case .instagramReels: "Instagram Reels"
        case .tiktok: "TikTok"
        case .facebook: "Facebook"
        case .appStore: "App Store"
        case .reddit: "Reddit"
        case .chatGPT: "ChatGPT"
        case .friendsFamily: "From friends or family"
        case .other: "Other"
        }
    }

    static func referralSymbol(_ source: ReferralSource) -> String {
        switch source {
        case .instagramReels: "camera"
        case .tiktok: "music.note"
        case .facebook: "f.circle.fill"
        case .appStore: "apple.logo"
        case .reddit: "bubble.left.and.bubble.right.fill"
        case .chatGPT: "sparkles"
        case .friendsFamily: "person.2.fill"
        case .other: "pencil"
        }
    }

    // MARK: - Persona

    static func personaTitle(_ persona: UserPersona) -> String {
        switch persona {
        case .workingProfessional: "Working professional"
        case .student: "Student"
        case .parent: "Parent"
        case .teacher: "Teacher"
        case .administrator: "Administrator"
        }
    }

    static func personaSubtitle(_ persona: UserPersona) -> String {
        switch persona {
        case .workingProfessional: "Learn Russian for work and travel"
        case .student: "School, university, or self-study"
        case .parent: "Help my child learn Russian"
        case .teacher: "Teach or tutor Russian"
        case .administrator: "Evaluate for my school or program"
        }
    }

    static func personaEmoji(_ persona: UserPersona) -> String {
        switch persona {
        case .workingProfessional: "💼"
        case .student: "📚"
        case .parent: "👨‍👩‍👧"
        case .teacher: "👩‍🏫"
        case .administrator: "🏫"
        }
    }

    // MARK: - Work field

    static func workFieldLabel(_ field: WorkField) -> String {
        switch field {
        case .businessOwner: "Business owner"
        case .creativeMedia: "Creative / Media"
        case .education: "Education"
        case .finance: "Finance"
        case .healthcare: "Healthcare"
        case .legal: "Legal"
        case .managerExecutive: "Manager / Executive"
        case .publicService: "Public Service"
        case .salesMarketing: "Sales / Marketing"
        }
    }

    static func workFieldEmoji(_ field: WorkField) -> String {
        switch field {
        case .businessOwner: "🏢"
        case .creativeMedia: "🎨"
        case .education: "🎓"
        case .finance: "💰"
        case .healthcare: "🏥"
        case .legal: "⚖️"
        case .managerExecutive: "👔"
        case .publicService: "🏛️"
        case .salesMarketing: "📈"
        }
    }

    static func workFieldRoleHighlight(_ field: WorkField) -> String {
        switch field {
        case .finance: "finance professionals"
        case .education: "educators"
        case .healthcare: "healthcare professionals"
        case .legal: "legal professionals"
        case .businessOwner: "business owners"
        case .creativeMedia: "creatives"
        case .managerExecutive: "managers and executives"
        case .publicService: "public service professionals"
        case .salesMarketing: "sales and marketing professionals"
        }
    }

    static func socialProofBullets(for field: WorkField) -> [String] {
        switch field {
        case .finance:
            return [
                "Practice business Russian phrases",
                "Prepare for meetings abroad",
                "Review financial news in Russian",
                "Chat through Russian PDF reports",
            ]
        default:
            return [
                "Build daily vocabulary habits",
                "Practice real-world conversations",
                "Track progress toward fluency",
            ]
        }
    }

    // MARK: - Primary goals by persona

    static func primaryGoals(for persona: UserPersona) -> [PrimaryGoal] {
        switch persona {
        case .workingProfessional:
            return [.focusMeetingsCalls, .notesTakenForMe, .summarizeDocs, .learnFaster, .somethingElse]
        case .teacher:
            return [.captureClassNotes, .aiPracticeTests, .meetingNotes, .testingForStudents, .somethingElse]
        case .student:
            return [.passExam, .dailyConversation, .grammarFoundations, .immersionContent, .somethingElse]
        case .parent:
            return [.helpChildHomework, .kidExamPrep, .learnTogether, .somethingElse]
        case .administrator:
            return [.pilotProgram, .teacherTools, .districtEvaluation, .somethingElse]
        }
    }

    static func primaryGoalLabel(_ goal: PrimaryGoal) -> String {
        switch goal {
        case .focusMeetingsCalls: "Focus in meetings and calls"
        case .notesTakenForMe: "Have my notes taken for me"
        case .summarizeDocs: "Summarize docs (videos, PDFs)"
        case .learnFaster: "Learn 10x faster"
        case .somethingElse: "Something else"
        case .captureClassNotes: "Capture & send class notes"
        case .aiPracticeTests: "Have AI make practice tests, etc"
        case .meetingNotes: "Have meeting notes taken for me"
        case .testingForStudents: "Testing Daily Russian for my students"
        case .passExam: "Pass an exam or certification"
        case .dailyConversation: "Hold daily conversations"
        case .grammarFoundations: "Master grammar foundations"
        case .immersionContent: "Immerse with videos and podcasts"
        case .helpChildHomework: "Help with homework"
        case .kidExamPrep: "Prep my child for an exam"
        case .learnTogether: "Learn together as a family"
        case .pilotProgram: "Pilot a program"
        case .teacherTools: "Tools for teachers"
        case .districtEvaluation: "Evaluate for my district or school"
        }
    }

    static func primaryGoalEmoji(_ goal: PrimaryGoal) -> String {
        switch goal {
        case .focusMeetingsCalls, .meetingNotes: "🎙️"
        case .notesTakenForMe, .captureClassNotes, .somethingElse: "✍️"
        case .summarizeDocs: "💻"
        case .learnFaster, .immersionContent: "📗"
        case .aiPracticeTests: "📝"
        case .testingForStudents, .districtEvaluation: "👀"
        case .passExam, .kidExamPrep: "📅"
        case .dailyConversation: "💬"
        case .grammarFoundations: "📖"
        case .helpChildHomework: "🏠"
        case .learnTogether: "👨‍👩‍👧"
        case .pilotProgram, .teacherTools: "🏫"
        }
    }

    // MARK: - Testimonials

    struct Testimonial {
        let role: String
        let quote: String
    }

    static func testimonial(for persona: UserPersona) -> Testimonial {
        switch persona {
        case .workingProfessional:
            return Testimonial(
                role: "Working professional",
                quote: "Daily Russian fits between meetings. Short drills keep me consistent without overwhelming my schedule."
            )
        case .student:
            return Testimonial(
                role: "University student",
                quote: "I finally stopped cramming the night before. Daily goals and practice tests keep me on track for my exam."
            )
        case .parent:
            return Testimonial(
                role: "Parent",
                quote: "My kid actually asks to do Russian practice now. The bite-sized lessons work better than a thick textbook."
            )
        case .teacher:
            return Testimonial(
                role: "Russian teacher",
                quote: "Daily Russian helps me focus on engaging students instead of rebuilding the same worksheets every week."
            )
        case .administrator:
            return Testimonial(
                role: "School administrator",
                quote: "We piloted Daily Russian in two classes. Teachers liked the clarity of progress data and daily structure."
            )
        }
    }

    // MARK: - Features

    static func featureTitle(_ feature: TopFeature) -> String {
        switch feature {
        case .vocabularyDrills: "Daily vocabulary drills"
        case .listeningPractice: "Listening practice"
        case .grammarGames: "Grammar games"
        case .structuredCourse: "Structured course path"
        }
    }

    static func featureIcon(_ feature: TopFeature) -> String {
        switch feature {
        case .vocabularyDrills: "text.book.closed.fill"
        case .listeningPractice: "headphones"
        case .grammarGames: "gamecontroller.fill"
        case .structuredCourse: "map.fill"
        }
    }

    // MARK: - Study focus

    static func studyFocusLabel(_ focus: StudyFocus) -> String {
        switch focus {
        case .specificClass: "Yes, a specific class"
        case .upcomingExam: "Yes, an upcoming exam"
        case .somethingElse: "Yes, something else"
        case .generalHelp: "No, just generally help me"
        }
    }

    static func studyFocusEmoji(_ focus: StudyFocus) -> String {
        switch focus {
        case .specificClass: "📗"
        case .upcomingExam: "📅"
        case .somethingElse: "👀"
        case .generalHelp: "📈"
        }
    }

    // MARK: - Daily goal

    static func dailyGoalLabel(_ goal: DailyGoal) -> String {
        switch goal {
        case .casual: "Casual - 10 min / day"
        case .regular: "Regular - 20 min / day"
        case .serious: "Serious - 60 min / day"
        case .intense: "Intense - 90+ min / day"
        }
    }

    static func dailyGoalEmoji(_ goal: DailyGoal) -> String {
        switch goal {
        case .casual: "🍃"
        case .regular: "🌱"
        case .serious: "🌿"
        case .intense: "🌳"
        }
    }
}

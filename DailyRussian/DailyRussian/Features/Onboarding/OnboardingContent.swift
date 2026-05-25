import Foundation

enum OnboardingContent {
    static let personalizeSubtitle = "Personalizing your Daily Russian..."

    // MARK: - Referral

    static func referralLabel(_ source: ReferralSource) -> String {
        switch source {
        case .instagram: "Instagram"
        case .tiktok: "TikTok"
        case .facebook: "Facebook"
        case .appStore: "App Store"
        case .reddit: "Reddit"
        case .chatGPT: "ChatGPT"
        case .friendsAndFamily: "From friends and family"
        case .other: "Other"
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

    // MARK: - Primary goals

    static func primaryGoals(for _: UserPersona) -> [PrimaryGoal] {
        [
            .conversation,
            .travel,
            .cultureMedia,
            .familyFriends,
            .workBusiness,
            .schoolExam,
            .heritage,
            .brainTraining,
        ]
    }

    static func primaryGoalLabel(_ goal: PrimaryGoal) -> String {
        switch goal {
        case .conversation: "Hold real conversations"
        case .travel: "Travel or live abroad"
        case .cultureMedia: "Understand movies, music, books..."
        case .familyFriends: "Talk with family or friends"
        case .workBusiness: "Use Russian for work"
        case .schoolExam: "Study for class or an exam"
        case .heritage: "Reconnect with heritage"
        case .brainTraining: "Learn for fun or mental challenge"
        }
    }

    static func primaryGoalEmoji(_ goal: PrimaryGoal) -> String {
        switch goal {
        case .conversation: "💬"
        case .travel: "✈️"
        case .cultureMedia: "🎧"
        case .familyFriends: "👨‍👩‍👧"
        case .workBusiness: "💼"
        case .schoolExam: "📚"
        case .heritage: "🏠"
        case .brainTraining: "🧠"
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

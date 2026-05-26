import SwiftUI
import WidgetKit

struct MainPlaceholderView: View {
    let profile: OnboardingProfile?
    let isShowingDictionary: Bool
    let dictionaryWordRank: Int?
    let onOpenDictionary: (Int?) -> Void
    let onCloseDictionary: () -> Void
    var onResetOnboarding: (() -> Void)?

    @State private var selectedTab: MainTab = .profile
    @State private var studyDeck = StudyDeckSession()

    var body: some View {
        ZStack {
            OnboardingTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                currentPage
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                MainBottomNavigationBar(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private var currentPage: some View {
        if isShowingDictionary {
            DictionaryPage(
                selectedRank: dictionaryWordRank,
                onSelectWord: { onOpenDictionary($0) },
                onClose: onCloseDictionary
            )
        } else {
            switch selectedTab {
            case .settings:
                SettingsPage()
            case .profile:
                ProfilePage(profile: profile, onResetOnboarding: onResetOnboarding)
            case .study:
                StudyPage(deck: $studyDeck, onOpenDictionary: onOpenDictionary)
            case .chat:
                PlaceholderMainPage(
                    title: "Chat",
                    subtitle: "Practice conversations with a Russian tutor will live here.",
                    icon: "bubble.left.and.bubble.right.fill"
                )
            }
        }
    }
}

private enum MainTab: CaseIterable {
    case settings
    case profile
    case study
    case chat

    var title: String {
        switch self {
        case .settings: "Settings"
        case .profile: "Profile"
        case .study: "Study"
        case .chat: "Chat"
        }
    }

    var systemImage: String {
        switch self {
        case .settings: "gearshape.fill"
        case .profile: "person.fill"
        case .study: "book.closed.fill"
        case .chat: "bubble.left.fill"
        }
    }
}

private struct MainBottomNavigationBar: View {
    @Binding var selectedTab: MainTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: tab.systemImage)
                            .font(.headline.weight(.semibold))
                        Text(tab.title)
                            .font(.caption2.weight(.semibold))
                    }
                    .foregroundStyle(selectedTab == tab ? OnboardingTheme.accent : OnboardingTheme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 6)
        .background {
            Rectangle()
                .fill(OnboardingTheme.background)
                .overlay(alignment: .top) {
                    Divider()
                        .overlay(Color.white.opacity(0.12))
                }
        }
    }
}

private struct SettingsPage: View {
    @State private var dailyWordFrequency = DailyWordStore.defaultDailyWordFrequency
    private let dailyWordStore = DailyWordStore()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                MainPageHeader(
                    title: "Settings",
                    subtitle: "Adjust how Daily Russian fits into your routine."
                )

                ProfileDataCard(title: "Daily word frequency") {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Choose how many words you want per day.")
                                    .font(.caption)
                                    .foregroundStyle(OnboardingTheme.secondaryText)
                            }

                            Spacer()

                            Text("\(dailyWordFrequency)")
                                .font(.title2.weight(.bold))
                                .foregroundStyle(OnboardingTheme.accent)
                        }

                        HStack(spacing: 12) {
                            Text("1")
                            Slider(
                                value: Binding(
                                    get: { Double(dailyWordFrequency) },
                                    set: { updateDailyWordFrequency(Int($0.rounded())) }
                                ),
                                in: Double(DailyWordStore.dailyWordFrequencyRange.lowerBound)...Double(DailyWordStore.dailyWordFrequencyRange.upperBound),
                                step: 1
                            )
                            .tint(OnboardingTheme.accent)
                            Text("20")
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(OnboardingTheme.secondaryText)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(.horizontal, OnboardingTheme.horizontalPadding)
            .padding(.top, 28)
            .padding(.bottom, 32)
        }
        .onAppear {
            dailyWordFrequency = dailyWordStore.dailyWordFrequency()
        }
    }

    private func updateDailyWordFrequency(_ value: Int) {
        dailyWordFrequency = min(
            max(value, DailyWordStore.dailyWordFrequencyRange.lowerBound),
            DailyWordStore.dailyWordFrequencyRange.upperBound
        )
        dailyWordStore.setDailyWordFrequency(dailyWordFrequency)
        WidgetCenter.shared.reloadAllTimelines()
    }
}

private struct ProfilePage: View {
    let profile: OnboardingProfile?
    var onResetOnboarding: (() -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                MainPageHeader(
                    title: "Your profile",
                    subtitle: "Here is the data collected during onboarding."
                )

                if let profile {
                    profileSummary(for: profile)
                } else {
                    ProfileDataCard(title: "No profile found") {
                        ProfileDataRow(label: "Status", value: "Complete onboarding to create a profile.")
                    }
                }

                if let onResetOnboarding {
                    Button("Reset onboarding (debug)", action: onResetOnboarding)
                        .font(.caption)
                        .foregroundStyle(OnboardingTheme.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 12)
                }
            }
            .padding(.horizontal, OnboardingTheme.horizontalPadding)
            .padding(.top, 28)
            .padding(.bottom, 32)
        }
    }

    @ViewBuilder
    private func profileSummary(for profile: OnboardingProfile) -> some View {
        ProfileDataCard(title: "Basics") {
            ProfileDataRow(label: "Referral source", value: referralSourceLabel(profile.referralSource))
            ProfileDataRow(label: "Persona", value: profile.persona.map(OnboardingContent.personaTitle) ?? "-")
            ProfileDataRow(label: "Work field", value: profile.workField.map(OnboardingContent.workFieldLabel) ?? "-")
            ProfileDataRow(label: "Study focus", value: studyFocusLabel(profile.studyFocus))
            ProfileDataRow(label: "Daily goal", value: profile.dailyGoal.map(OnboardingContent.dailyGoalLabel) ?? "-")
        }

        ProfileDataCard(title: "Motivations") {
            ProfileDataRow(label: "Primary goals", value: profile.primaryGoals.map(OnboardingContent.primaryGoalLabel))
            ProfileDataRow(label: "Top features", value: profile.topFeatures.map(OnboardingContent.featureTitle))
        }

        ProfileDataCard(title: "App metadata") {
            ProfileDataRow(label: "Locale", value: profile.localeIdentifier ?? "-")
            ProfileDataRow(label: "App version", value: profile.appVersion ?? "-")
            ProfileDataRow(label: "Completed at", value: formattedDate(profile.onboardingCompletedAt))
        }
    }

    private func referralSourceLabel(_ answer: OnboardingAnswer?) -> String {
        guard let answer else { return "-" }
        if answer.custom == true {
            return "\(answer.value) (custom)"
        }

        return ReferralSource.allCases.first { $0.selectionID == answer.value }
            .map(OnboardingContent.referralLabel) ?? answer.value
    }

    private func studyFocusLabel(_ answer: OnboardingAnswer?) -> String {
        guard let answer else { return "-" }
        if answer.custom == true {
            return "\(answer.value) (custom)"
        }

        return StudyFocus.allCases.first { $0.selectionID == answer.value }
            .map(OnboardingContent.studyFocusLabel) ?? answer.value
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "-" }
        return date.formatted(date: .abbreviated, time: .shortened)
    }
}

private struct StudyPage: View {
    @Binding var deck: StudyDeckSession
    let onOpenDictionary: (Int?) -> Void
    @State private var dailyWordStore = DailyWordStore()
    @State private var isRevealed = false
    @State private var cardIdentity = UUID()

    private var currentWord: DailyRussianWord? {
        guard deck.reviewWords.indices.contains(deck.currentIndex) else { return nil }
        return deck.reviewWords[deck.currentIndex]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                MainPageHeader(
                    title: "Study",
                    subtitle: "Review words with quick flashcards and rank what needs more practice."
                )

                Spacer()

                Button {
                    onOpenDictionary(nil)
                } label: {
                    Image(systemName: "text.book.closed.fill")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(OnboardingTheme.primaryText)
                        .frame(width: 44, height: 44)
                        .background(OnboardingTheme.cardBackground, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Open dictionary")
            }
            .padding(.horizontal, OnboardingTheme.horizontalPadding)
            .padding(.top, 28)

            Spacer(minLength: 20)

            if let currentWord {
                Text(isRevealed ? "How well did you remember it?" : "Tap the card to reveal the translation.")
                    .font(.footnote)
                    .foregroundStyle(OnboardingTheme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, OnboardingTheme.horizontalPadding)

                flashcard(for: currentWord)
                    .padding(.horizontal, OnboardingTheme.horizontalPadding)

                Button {
                    onOpenDictionary(currentWord.rank)
                } label: {
                    Text("Open in dictionary")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(OnboardingTheme.accent)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)

                ratingButtons(for: currentWord)
                    .padding(.horizontal, OnboardingTheme.horizontalPadding)
            } else {
                PlaceholderMainPage(
                    title: "No cards yet",
                    subtitle: "Words will appear here as your daily list grows.",
                    icon: "checkmark.circle.fill"
                )
            }

            Spacer(minLength: 20)
        }
        .onAppear {
            if deck.reviewWords.isEmpty {
                loadMoreWords()
            }
        }
    }

    private func flashcard(for word: DailyRussianWord) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                isRevealed.toggle()
            }
        } label: {
            VStack(spacing: 18) {
                VStack(spacing: 12) {
                    Text(word.russian)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(OnboardingTheme.primaryText)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)

                    Text(word.pronunciation)
                        .font(.title3.weight(.medium).italic())
                        .foregroundStyle(OnboardingTheme.primaryText.opacity(0.68))
                        .multilineTextAlignment(.center)
                }

                if isRevealed {
                    VStack(spacing: 16) {
                        Divider()
                            .overlay(Color.white.opacity(0.14))

                        Text(word.translation)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(OnboardingTheme.accent)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)

                        if !word.details.isEmpty {
                            Text(word.details)
                                .font(.footnote)
                                .foregroundStyle(OnboardingTheme.secondaryText)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .padding(28)
            .frame(maxWidth: .infinity, minHeight: 320)
            .background(OnboardingTheme.cardBackground, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }
            .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .id(cardIdentity)
        .buttonStyle(.plain)
    }

    private func ratingButtons(for word: DailyRussianWord) -> some View {
        HStack(spacing: 10) {
            KnowledgeRatingButton(title: "Hard", color: OnboardingTheme.accent, isEnabled: isRevealed) {
                rate(word, as: .hard)
            }
            KnowledgeRatingButton(title: "Medium", color: OnboardingTheme.glowWarm, isEnabled: isRevealed) {
                rate(word, as: .medium)
            }
            KnowledgeRatingButton(title: "Easy", color: OnboardingTheme.checkGreen, isEnabled: isRevealed) {
                rate(word, as: .easy)
            }
        }
    }

    private func rate(_ word: DailyRussianWord, as rating: DailyWordKnowledgeRating) {
        dailyWordStore.rateWord(rank: word.rank, as: rating)
        deck.reviewedRanks.insert(word.rank)

        withAnimation(.easeInOut(duration: 0.16)) {
            isRevealed = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            deck.currentIndex += 1
            cardIdentity = UUID()
        }

        if deck.currentIndex >= deck.reviewWords.count - 5 {
            loadMoreWords()
        }
    }

    private func loadMoreWords() {
        let queuedRanks = Set(deck.reviewWords.map(\.rank))
        let excludedRanks = deck.reviewedRanks.union(queuedRanks)
        let newWords = dailyWordStore.reviewWords(excluding: excludedRanks, limit: 20)
        deck.reviewWords.append(contentsOf: newWords)
    }
}

private struct StudyDeckSession {
    var reviewWords: [DailyRussianWord] = []
    var reviewedRanks: Set<Int> = []
    var currentIndex = 0
}

private struct DictionaryPage: View {
    let selectedRank: Int?
    let onSelectWord: (Int?) -> Void
    let onClose: () -> Void

    @State private var searchText = ""

    private var selectedWord: DailyRussianWord? {
        guard let selectedRank else { return nil }
        return DailyWordCatalog.words.first { $0.rank == selectedRank }
    }

    private var filteredWords: [DailyRussianWord] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else { return DailyWordCatalog.words }

        return DailyWordCatalog.words.filter { word in
            word.russian.lowercased().contains(query)
                || word.pronunciation.lowercased().contains(query)
                || word.translation.lowercased().contains(query)
        }
    }

    var body: some View {
        if let selectedWord {
            DictionaryWordDetailPage(word: selectedWord) {
                onSelectWord(nil)
            } onClose: {
                onClose()
            }
        } else {
            dictionaryList
        }
    }

    private var dictionaryList: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                MainPageHeader(
                    title: "Dictionary",
                    subtitle: "Browse the most common Russian words."
                )

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(OnboardingTheme.primaryText)
                        .frame(width: 44, height: 44)
                        .background(OnboardingTheme.cardBackground, in: Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, OnboardingTheme.horizontalPadding)
            .padding(.top, 28)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(OnboardingTheme.secondaryText)
                TextField("Search Russian, pronunciation, meaning", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundStyle(OnboardingTheme.primaryText)
            }
            .font(.callout)
            .padding(14)
            .background(OnboardingTheme.cardBackground, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, OnboardingTheme.horizontalPadding)

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(filteredWords, id: \.rank) { word in
                        Button {
                            onSelectWord(word.rank)
                        } label: {
                            DictionaryListRow(word: word)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, OnboardingTheme.horizontalPadding)
                .padding(.bottom, 32)
            }
        }
    }
}

private struct DictionaryListRow: View {
    let word: DailyRussianWord

    var body: some View {
        HStack(spacing: 14) {
            Text("\(word.rank)")
                .font(.caption.weight(.bold))
                .foregroundStyle(OnboardingTheme.secondaryText)
                .frame(width: 38, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(word.russian)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(OnboardingTheme.primaryText)
                Text("\(word.pronunciation) • \(word.translation)")
                    .font(.caption)
                    .foregroundStyle(OnboardingTheme.secondaryText)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(OnboardingTheme.secondaryText)
        }
        .padding(14)
        .background(OnboardingTheme.cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct DictionaryWordDetailPage: View {
    let word: DailyRussianWord
    let onBackToList: () -> Void
    let onClose: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Button(action: onBackToList) {
                        Image(systemName: "chevron.left")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(OnboardingTheme.primaryText)
                            .frame(width: 44, height: 44)
                            .background(OnboardingTheme.cardBackground, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Back to dictionary")

                    Spacer()

                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(OnboardingTheme.primaryText)
                            .frame(width: 44, height: 44)
                            .background(OnboardingTheme.cardBackground, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close dictionary")
                }

                VStack(alignment: .leading, spacing: 10) {
                    if usesCompactGrammarLayout(word) {
                        compactTitleLine(for: word)
                    } else {
                        Text(word.russian)
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(OnboardingTheme.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(word.pronunciation)
                            .font(.title3.weight(.medium).italic())
                            .foregroundStyle(OnboardingTheme.primaryText.opacity(0.68))
                    }

                    Text(word.translation)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(OnboardingTheme.accent)
                        .fixedSize(horizontal: false, vertical: true)
                }

                ProfileDataCard(title: "Details") {
                    ProfileDataRow(label: "Word class", value: wordClassLabel)
                    ProfileDataRow(
                        label: "Notes",
                        value: word.details.isEmpty ? "Detailed grammar notes will appear here as the dictionary grows." : word.details
                    )
                }

                ProfileDataCard(title: "Examples") {
                    if word.examples.isEmpty {
                        ProfileDataRow(label: "Coming soon", value: "Example sentences will be added here.")
                    } else {
                        ForEach(Array(word.examples.enumerated()), id: \.offset) { _, example in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(example.russian)
                                    .font(.callout.weight(.semibold))
                                    .foregroundStyle(OnboardingTheme.primaryText)
                                Text(example.translation)
                                    .font(.caption)
                                    .foregroundStyle(OnboardingTheme.secondaryText)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 10)
                        }
                    }
                }
            }
            .padding(.horizontal, OnboardingTheme.horizontalPadding)
            .padding(.top, 20)
            .padding(.bottom, 32)
        }
    }

    private var wordClassLabel: String {
        word.partOfSpeech
            .split(separator: ",")
            .map { part in
                part.trimmingCharacters(in: .whitespacesAndNewlines)
                    .split(separator: " ")
                    .map { $0.prefix(1).uppercased() + $0.dropFirst() }
                    .joined(separator: " ")
            }
            .joined(separator: ", ")
    }

    private func compactTitleLine(for word: DailyRussianWord) -> some View {
        HStack(spacing: 0) {
            Text(word.russian)
                .font(.system(size: 38, weight: .bold))
                .foregroundStyle(OnboardingTheme.primaryText)
            Text(" • ")
                .font(.system(size: 38, weight: .regular))
                .foregroundStyle(OnboardingTheme.primaryText.opacity(0.9))
            Text(word.pronunciation)
                .font(.title3.weight(.medium).italic())
                .foregroundStyle(OnboardingTheme.primaryText.opacity(0.68))
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }

    private func usesCompactGrammarLayout(_ word: DailyRussianWord) -> Bool {
        let wordClass = word.partOfSpeech.lowercased()
        return word.russian.count <= 4
            || wordClass.contains("pron")
            || wordClass.contains("prep")
            || wordClass.contains("particle")
            || wordClass.contains("adverb")
            || wordClass.contains("conj")
    }
}

private struct KnowledgeRatingButton: View {
    let title: String
    let color: Color
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    isEnabled ? color.opacity(0.88) : OnboardingTheme.cardBackground,
                    in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(isEnabled ? Color.clear : Color.white.opacity(0.10), lineWidth: 1)
                }
                .opacity(isEnabled ? 1 : 0.45)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

private struct PlaceholderMainPage: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(OnboardingTheme.accent)
                .frame(width: 84, height: 84)
                .background(OnboardingTheme.cardBackground, in: Circle())

            Text(title)
                .font(.largeTitle.bold())
                .foregroundStyle(OnboardingTheme.primaryText)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(OnboardingTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 42)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct MainPageHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle.bold())
                .foregroundStyle(OnboardingTheme.primaryText)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(OnboardingTheme.secondaryText)
        }
    }
}

private struct ProfileDataCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(OnboardingTheme.primaryText)

            VStack(spacing: 0) {
                content()
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(OnboardingTheme.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        }
    }
}

private struct ProfileDataRow: View {
    let label: String
    let value: String

    init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    init(label: String, value values: [String]) {
        self.label = label
        self.value = values.isEmpty ? "-" : values.joined(separator: ", ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(OnboardingTheme.secondaryText)

            Text(value)
                .font(.callout.weight(.semibold))
                .foregroundStyle(OnboardingTheme.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
    }
}

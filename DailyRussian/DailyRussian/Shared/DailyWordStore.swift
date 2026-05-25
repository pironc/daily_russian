import Foundation

struct DailyRussianWord: Codable, Equatable, Identifiable {
    let id: String
    let russian: String
    let pronunciation: String
    let shortMeaning: String
    let explanation: String
    let exampleRussian: String
    let exampleMeaning: String
}

struct DailyWordState: Codable, Equatable {
    var displayedWordIDs: [String] = []
    var currentWordID: String?
    var currentDayStart: Date?
}

enum DailyWordCatalog {
    static let words: [DailyRussianWord] = [
        DailyRussianWord(id: "privet", russian: "Привет", pronunciation: "privet", shortMeaning: "hello", explanation: "A casual greeting used with friends, family, and people you know well.", exampleRussian: "Привет, как дела?", exampleMeaning: "Hi, how are you?"),
        DailyRussianWord(id: "pozhaluysta", russian: "Пожалуйста", pronunciation: "pozhaluysta", shortMeaning: "please / you're welcome", explanation: "Used both to ask politely and to respond to thanks.", exampleRussian: "Пожалуйста, говорите медленно.", exampleMeaning: "Please speak slowly."),
        DailyRussianWord(id: "segodnya", russian: "Сегодня", pronunciation: "segodnya", shortMeaning: "today", explanation: "An adverb used for the current day.", exampleRussian: "Сегодня холодно.", exampleMeaning: "It is cold today."),
        DailyRussianWord(id: "dostoprimechatelnost", russian: "Достопримечательность", pronunciation: "dostoprimechatelnost", shortMeaning: "landmark / attraction", explanation: "A long noun for a notable place tourists visit, such as a monument or landmark.", exampleRussian: "Это главная достопримечательность города.", exampleMeaning: "This is the city's main landmark."),
        DailyRussianWord(id: "elektrostantsiya", russian: "Электростанция", pronunciation: "elektrostantsiya", shortMeaning: "power station", explanation: "A compound-style noun for a facility that produces electricity.", exampleRussian: "Электростанция находится за городом.", exampleMeaning: "The power station is outside the city."),
        DailyRussianWord(id: "blagodarnost", russian: "Благодарность", pronunciation: "blagodarnost", shortMeaning: "gratitude", explanation: "A noun for the feeling or expression of thankfulness.", exampleRussian: "Я чувствую благодарность.", exampleMeaning: "I feel gratitude."),
        DailyRussianWord(id: "puteshestvie", russian: "Путешествие", pronunciation: "puteshestvie", shortMeaning: "journey / trip", explanation: "A noun for a journey, trip, or travel experience.", exampleRussian: "Наше путешествие начинается завтра.", exampleMeaning: "Our journey starts tomorrow."),
        DailyRussianWord(id: "vzaimoponimanie", russian: "Взаимопонимание", pronunciation: "vzaimoponimanie", shortMeaning: "mutual understanding", explanation: "A long abstract noun for understanding between people.", exampleRussian: "Нам нужно взаимопонимание.", exampleMeaning: "We need mutual understanding."),
        DailyRussianWord(id: "otvetstvennost", russian: "Ответственность", pronunciation: "otvetstvennost", shortMeaning: "responsibility", explanation: "A noun for responsibility or accountability.", exampleRussian: "Это большая ответственность.", exampleMeaning: "This is a big responsibility."),
        DailyRussianWord(id: "samostoyatelnost", russian: "Самостоятельность", pronunciation: "samostoyatelnost", shortMeaning: "independence", explanation: "A noun for the ability to act or live independently.", exampleRussian: "Самостоятельность важна.", exampleMeaning: "Independence is important."),
    ]
}

struct DailyWordStore {
    static let appGroupIdentifier = "group.com.pironc.DailyRussian"

    private enum Keys {
        static let state = "dailyWordState"
    }

    private let defaults: UserDefaults
    private let calendar: Calendar

    init(
        defaults: UserDefaults = UserDefaults(suiteName: DailyWordStore.appGroupIdentifier) ?? .standard,
        calendar: Calendar = .current
    ) {
        self.defaults = defaults
        self.calendar = calendar
    }

    mutating func wordForToday(now: Date = Date()) -> DailyRussianWord? {
        var state = loadState()
        let todayStart = calendar.startOfDay(for: now)

        #if DEBUG
        return advanceToNextWord(in: &state, dayStart: todayStart, allowsTestingReset: true)
        #else
        if state.currentDayStart == todayStart,
           let currentWord = word(withID: state.currentWordID) {
            return currentWord
        }

        return advanceToNextWord(in: &state, dayStart: todayStart)
        #endif
    }

    func nextRefreshDate(after date: Date = Date()) -> Date {
        #if DEBUG
        return date.addingTimeInterval(15)
        #else
        calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: date)) ?? date.addingTimeInterval(86_400)
        #endif
    }

    private func loadState() -> DailyWordState {
        guard let data = defaults.data(forKey: Keys.state),
              let state = try? JSONDecoder().decode(DailyWordState.self, from: data) else {
            return DailyWordState()
        }

        return state
    }

    private func saveState(_ state: DailyWordState) {
        guard let data = try? JSONEncoder().encode(state) else { return }
        defaults.set(data, forKey: Keys.state)
    }

    private func word(withID id: String?) -> DailyRussianWord? {
        guard let id else { return nil }
        return DailyWordCatalog.words.first { $0.id == id }
    }

    private func advanceToNextWord(
        in state: inout DailyWordState,
        dayStart: Date,
        allowsTestingReset: Bool = false
    ) -> DailyRussianWord? {
        var displayedWordIDs = state.displayedWordIDs

        if allowsTestingReset,
           nextUnseenWord(excluding: displayedWordIDs) == nil {
            displayedWordIDs = []
            state.displayedWordIDs = []
        }

        guard let nextWord = nextUnseenWord(excluding: displayedWordIDs) else {
            state.currentWordID = nil
            state.currentDayStart = dayStart
            saveState(state)
            return nil
        }

        state.currentWordID = nextWord.id
        state.currentDayStart = dayStart
        state.displayedWordIDs.append(nextWord.id)
        saveState(state)
        return nextWord
    }

    private func nextUnseenWord(excluding displayedWordIDs: [String]) -> DailyRussianWord? {
        DailyWordCatalog.words
            .filter { !displayedWordIDs.contains($0.id) }
            .randomElement()
    }
}

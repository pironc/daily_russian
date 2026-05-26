import Foundation

struct DailyRussianWordExample: Codable, Equatable {
    let russian: String
    let translation: String
}

struct DailyRussianWord: Codable, Equatable {
    let rank: Int
    let russian: String
    let pronunciation: String
    let translation: String
    let partOfSpeech: String
    let details: String
    let examples: [DailyRussianWordExample]
}

struct DailyWordState: Codable, Equatable {
    var displayedWordRanks: [Int] = []
    var currentWordRank: Int?
    var currentDayStart: Date?
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
           let currentWord = word(withRank: state.currentWordRank) {
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

    private func word(withRank rank: Int?) -> DailyRussianWord? {
        guard let rank else { return nil }
        return DailyWordCatalog.words.first { $0.rank == rank }
    }

    private func advanceToNextWord(
        in state: inout DailyWordState,
        dayStart: Date,
        allowsTestingReset: Bool = false
    ) -> DailyRussianWord? {
        var displayedWordRanks = state.displayedWordRanks

        if allowsTestingReset,
           nextUnseenWord(excluding: displayedWordRanks) == nil {
            displayedWordRanks = []
            state.displayedWordRanks = []
        }

        guard let nextWord = nextUnseenWord(excluding: displayedWordRanks) else {
            state.currentWordRank = nil
            state.currentDayStart = dayStart
            saveState(state)
            return nil
        }

        state.currentWordRank = nextWord.rank
        state.currentDayStart = dayStart
        state.displayedWordRanks.append(nextWord.rank)
        saveState(state)
        return nextWord
    }

    private func nextUnseenWord(excluding displayedWordRanks: [Int]) -> DailyRussianWord? {
        DailyWordCatalog.words
            .filter { !displayedWordRanks.contains($0.rank) }
            .randomElement()
    }
}

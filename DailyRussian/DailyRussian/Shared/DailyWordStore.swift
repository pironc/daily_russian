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

enum DailyWordKnowledgeRating: Int, Codable, Equatable {
    case unranked = 0
    case hard = 1
    case medium = 2
    case easy = 3
}

struct DailyWordRatingRecord: Codable, Equatable {
    var rating: DailyWordKnowledgeRating
    var updatedAt: Date
}

struct DailyWordTimelineItem: Equatable {
    let date: Date
    let word: DailyRussianWord?
}

struct DailyWordState: Codable, Equatable {
    var dailyWordRanks: [Int] = []
    var displayedWordRanks: [Int] = []
    var currentWordRank: Int?
    var currentDayStart: Date?
    var dailyWordFrequency: Int = DailyWordStore.defaultDailyWordFrequency
    var ratings: [Int: DailyWordRatingRecord] = [:]

    init() {}

    private enum CodingKeys: String, CodingKey {
        case dailyWordRanks
        case displayedWordRanks
        case currentWordRank
        case currentDayStart
        case dailyWordFrequency
        case ratings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dailyWordRanks = try container.decodeIfPresent([Int].self, forKey: .dailyWordRanks) ?? []
        displayedWordRanks = try container.decodeIfPresent([Int].self, forKey: .displayedWordRanks) ?? []
        currentWordRank = try container.decodeIfPresent(Int.self, forKey: .currentWordRank)
        currentDayStart = try container.decodeIfPresent(Date.self, forKey: .currentDayStart)
        dailyWordFrequency = try container.decodeIfPresent(Int.self, forKey: .dailyWordFrequency) ?? DailyWordStore.defaultDailyWordFrequency
        ratings = try container.decodeIfPresent([Int: DailyWordRatingRecord].self, forKey: .ratings) ?? [:]
    }
}

struct DailyWordStore {
    static let appGroupIdentifier = "group.com.pironc.DailyRussian"
    static let defaultDailyWordFrequency = 1
    static let dailyWordFrequencyRange = 1...20

    private enum Keys {
        static let state = "dailyWordState"
        static let dailyWordFrequency = "dailyWordFrequency"
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
        refreshDailyWordsIfNeeded(in: &state, now: now)

        guard let rank = currentDisplayRank(from: state.dailyWordRanks, now: now) else {
            state.currentWordRank = nil
            saveState(state)
            return nil
        }

        state.currentWordRank = rank
        saveState(state)
        return word(withRank: rank)
    }

    func nextRefreshDate(after date: Date = Date()) -> Date {
        let scheduleStart = scheduleStart(for: date)
        let activeStart = learningWindowStart(for: scheduleStart)
        let activeEnd = learningWindowEnd(for: scheduleStart)

        if date < activeStart {
            return activeStart
        }

        if date >= activeEnd {
            return calendar.date(byAdding: .day, value: 1, to: scheduleStart) ?? date.addingTimeInterval(18_000)
        }

        let interval: TimeInterval = 15 * 60
        let elapsed = date.timeIntervalSince(activeStart)
        let nextSlotOffset = (floor(elapsed / interval) + 1) * interval
        return activeStart.addingTimeInterval(nextSlotOffset)
    }

    func dailyWordFrequency() -> Int {
        let value = defaults.integer(forKey: Keys.dailyWordFrequency)
        guard value > 0 else { return Self.defaultDailyWordFrequency }
        return Self.dailyWordFrequencyRange.clamped(value)
    }

    func setDailyWordFrequency(_ value: Int) {
        defaults.set(Self.dailyWordFrequencyRange.clamped(value), forKey: Keys.dailyWordFrequency)
    }

    mutating func timelineItems(startingAt date: Date = Date()) -> [DailyWordTimelineItem] {
        var state = loadState()
        refreshDailyWordsIfNeeded(in: &state, now: date)
        saveState(state)

        let scheduleStart = scheduleStart(for: date)
        let nextReset = calendar.date(byAdding: .day, value: 1, to: scheduleStart) ?? date.addingTimeInterval(86_400)
        var itemDate = date
        var items: [DailyWordTimelineItem] = []

        while itemDate <= nextReset, items.count < 80 {
            let rank = currentDisplayRank(from: state.dailyWordRanks, now: itemDate)
            items.append(DailyWordTimelineItem(date: itemDate, word: word(withRank: rank)))
            itemDate = nextRefreshDate(after: itemDate)
        }

        if items.isEmpty {
            items.append(DailyWordTimelineItem(date: date, word: nil))
        }

        return items
    }

    func reviewWords(excluding excludedRanks: Set<Int> = [], limit: Int = 20) -> [DailyRussianWord] {
        let state = loadState()
        let orderedRanks = reviewCandidateRanks(from: state, excluding: excludedRanks, prefersRankedMix: excludedRanks.isEmpty)
        return orderedRanks
            .prefix(limit)
            .compactMap(word(withRank:))
    }

    func rateWord(rank: Int, as rating: DailyWordKnowledgeRating, now: Date = Date()) {
        var state = loadState()
        state.ratings[rank] = DailyWordRatingRecord(rating: rating, updatedAt: now)
        if !state.displayedWordRanks.contains(rank) {
            state.displayedWordRanks.append(rank)
        }
        saveState(state)
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

    private func refreshDailyWordsIfNeeded(in state: inout DailyWordState, now: Date) {
        let scheduleStart = scheduleStart(for: now)
        let frequency = dailyWordFrequency()

        guard state.currentDayStart != scheduleStart
            || state.dailyWordFrequency != frequency
            || state.dailyWordRanks.isEmpty else {
            return
        }

        let selectedRanks = selectDailyWordRanks(count: frequency, from: state)
        state.currentDayStart = scheduleStart
        state.dailyWordFrequency = frequency
        state.dailyWordRanks = selectedRanks
        state.currentWordRank = selectedRanks.first

        for rank in selectedRanks where !state.displayedWordRanks.contains(rank) {
            state.displayedWordRanks.append(rank)
        }
    }

    private func currentDisplayRank(from dailyWordRanks: [Int], now: Date) -> Int? {
        guard !dailyWordRanks.isEmpty else { return nil }

        let scheduleStart = scheduleStart(for: now)
        let activeStart = learningWindowStart(for: scheduleStart)
        let activeEnd = learningWindowEnd(for: scheduleStart)

        if now < activeStart {
            return dailyWordRanks.first
        }

        if now >= activeEnd {
            return dailyWordRanks.last
        }

        let slot = Int(now.timeIntervalSince(activeStart) / (15 * 60))
        return dailyWordRanks[slot % dailyWordRanks.count]
    }

    private func scheduleStart(for date: Date) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 4
        components.minute = 0
        components.second = 0

        let todayReset = calendar.date(from: components) ?? calendar.startOfDay(for: date)
        if date >= todayReset {
            return todayReset
        }

        return calendar.date(byAdding: .day, value: -1, to: todayReset) ?? todayReset
    }

    private func learningWindowStart(for scheduleStart: Date) -> Date {
        calendar.date(byAdding: .hour, value: 3, to: scheduleStart) ?? scheduleStart.addingTimeInterval(10_800)
    }

    private func learningWindowEnd(for scheduleStart: Date) -> Date {
        calendar.date(byAdding: .hour, value: 19, to: scheduleStart) ?? scheduleStart.addingTimeInterval(68_400)
    }

    private func selectDailyWordRanks(count: Int, from state: DailyWordState) -> [Int] {
        let count = Self.dailyWordFrequencyRange.clamped(count)
        var selected: [Int] = []
        let rankedRecords = state.ratings.filter { $0.value.rating != .unranked }
        let hasRankedWords = !rankedRecords.isEmpty

        if hasRankedWords {
            appendCandidates(oldestRanks(for: .hard, in: state), to: &selected, limit: Int((Double(count) * 0.25).rounded()))
            appendCandidates(oldestRanks(for: .medium, in: state), to: &selected, limit: Int((Double(count) * 0.20).rounded()))
        } else {
            appendCandidates(previouslySeenRanks(from: state), to: &selected, limit: Int((Double(count) * 0.10).rounded()))
        }

        appendCandidates(newWordRanks(from: state), to: &selected, limit: count - selected.count)
        appendCandidates(reviewCandidateRanks(from: state, excluding: Set(selected), prefersRankedMix: true), to: &selected, limit: count - selected.count)
        appendCandidates(DailyWordCatalog.words.map(\.rank), to: &selected, limit: count - selected.count)
        return selected
    }

    private func oldestRanks(for rating: DailyWordKnowledgeRating, in state: DailyWordState) -> [Int] {
        state.ratings
            .filter { $0.value.rating == rating }
            .sorted { $0.value.updatedAt < $1.value.updatedAt }
            .map(\.key)
    }

    private func previouslySeenRanks(from state: DailyWordState) -> [Int] {
        state.displayedWordRanks.filter { rank in
            state.ratings[rank]?.rating != .easy
        }
    }

    private func unrankedWordRanks(from state: DailyWordState) -> [Int] {
        DailyWordCatalog.words
            .map(\.rank)
            .filter { state.ratings[$0] == nil || state.ratings[$0]?.rating == .unranked }
    }

    private func newWordRanks(from state: DailyWordState) -> [Int] {
        let seenRanks = Set(state.displayedWordRanks)
        return DailyWordCatalog.words
            .map(\.rank)
            .filter { !seenRanks.contains($0) && state.ratings[$0]?.rating != .easy }
    }

    private func easyRanks(from state: DailyWordState) -> [Int] {
        oldestRanks(for: .easy, in: state)
    }

    private func reviewCandidateRanks(
        from state: DailyWordState,
        excluding excludedRanks: Set<Int>,
        prefersRankedMix: Bool = false
    ) -> [Int] {
        var ranks: [Int] = []

        if prefersRankedMix {
            let rankedLimit = 5
            appendCandidates(oldestRanks(for: .hard, in: state), to: &ranks, limit: rankedLimit, excluding: excludedRanks)
            appendCandidates(oldestRanks(for: .medium, in: state), to: &ranks, limit: rankedLimit - ranks.count, excluding: excludedRanks)
        }

        appendCandidates(newWordRanks(from: state), to: &ranks, limit: Int.max, excluding: excludedRanks)
        appendCandidates(unrankedWordRanks(from: state), to: &ranks, limit: Int.max, excluding: excludedRanks)
        appendCandidates(oldestRanks(for: .hard, in: state), to: &ranks, limit: Int.max, excluding: excludedRanks)
        appendCandidates(oldestRanks(for: .medium, in: state), to: &ranks, limit: Int.max, excluding: excludedRanks)
        appendCandidates(easyRanks(from: state), to: &ranks, limit: Int.max, excluding: excludedRanks)
        return ranks
    }

    private func appendCandidates(
        _ candidates: [Int],
        to selected: inout [Int],
        limit: Int,
        excluding excludedRanks: Set<Int> = []
    ) {
        guard limit > 0 else { return }

        var added = 0
        for rank in candidates where added < limit {
            if selected.contains(rank) || excludedRanks.contains(rank) {
                continue
            }

            selected.append(rank)
            added += 1
        }
    }
}

private extension ClosedRange where Bound == Int {
    func clamped(_ value: Int) -> Int {
        min(max(value, lowerBound), upperBound)
    }
}

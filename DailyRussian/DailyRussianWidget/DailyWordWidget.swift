import SwiftUI
import WidgetKit

struct DailyWordEntry: TimelineEntry {
    let date: Date
    let word: DailyRussianWord?
}

struct DailyWordProvider: TimelineProvider {
    func placeholder(in context: Context) -> DailyWordEntry {
        DailyWordEntry(date: Date(), word: DailyWordCatalog.words.first)
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyWordEntry) -> Void) {
        var store = DailyWordStore()
        completion(DailyWordEntry(date: Date(), word: store.wordForToday()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyWordEntry>) -> Void) {
        let now = Date()
        var store = DailyWordStore()
        let entries = store.timelineItems(startingAt: now).map {
            DailyWordEntry(date: $0.date, word: $0.word)
        }
        completion(Timeline(entries: entries, policy: .after(store.nextRefreshDate(after: entries.last?.date ?? now))))
    }
}

struct DailyWordWidgetView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    let entry: DailyWordEntry

    var body: some View {
        Group {
            switch widgetFamily {
            case .accessoryInline:
                inlineContent
            case .accessoryCircular:
                circularContent
            case .accessoryRectangular:
                lockScreenRectangularContent
            default:
                springboardContent
            }
        }
        .widgetURL(dictionaryURL(for: entry.word))
    }

    private var springboardContent: some View {
        VStack(alignment: .leading, spacing: 7) {
            if let word = entry.word {
                if usesCompactGrammarLayout(word) {
                    compactTitleLine(
                        for: word,
                        wordFont: .title3.weight(.bold),
                        separatorFont: .title3,
                        pronunciationFont: .subheadline.weight(.medium).italic(),
                        wordColor: .white,
                        separatorColor: .white.opacity(0.9),
                        pronunciationColor: .white.opacity(0.68)
                    )
                        .lineLimit(1)
                        .minimumScaleFactor(0.35)

                    Text(word.translation)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(3)
                        .minimumScaleFactor(0.6)
                } else {
                    Text(word.russian)
                        .font(.title.weight(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)

                    Text(word.pronunciation)
                        .font(.subheadline.weight(.medium).italic())
                        .foregroundStyle(.white.opacity(0.68))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    Text(word.translation)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(2)
                        .minimumScaleFactor(0.65)
                }
            } else {
                Text("All words learned")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text("You finished the list")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }

    private var lockScreenRectangularContent: some View {
        VStack(alignment: .center, spacing: 3) {
            if let word = entry.word {
                if usesCompactGrammarLayout(word) {
                    compactTitleLine(
                        for: word,
                        wordFont: .headline.weight(.bold),
                        separatorFont: .headline,
                        pronunciationFont: .caption.weight(.medium).italic(),
                        wordColor: .primary,
                        separatorColor: .primary,
                        pronunciationColor: .primary.opacity(0.75)
                    )
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .multilineTextAlignment(.center)

                    Text(word.translation)
                        .font(.caption2)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                } else {
                    Text(word.russian)
                        .font(.headline.weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.45)
                        .multilineTextAlignment(.center)

                    Text(word.pronunciation)
                        .font(.caption.weight(.medium).italic())
                        .foregroundStyle(.primary.opacity(0.75))
                        .lineLimit(1)
                        .minimumScaleFactor(0.55)
                        .multilineTextAlignment(.center)

                    Text(word.translation)
                        .font(.caption2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.55)
                        .multilineTextAlignment(.center)
                }
            } else {
                Text("All words learned")
                    .font(.headline.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.center)
                Text("You finished the list")
                    .font(.caption2)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .widgetAccentable()
    }

    private var circularContent: some View {
        VStack(alignment: .center, spacing: 1) {
            if let word = entry.word {
                if usesCompactGrammarLayout(word) {
                    compactTitleLine(
                        for: word,
                        wordFont: .caption.weight(.bold),
                        separatorFont: .caption,
                        pronunciationFont: .caption2.italic(),
                        wordColor: .primary,
                        separatorColor: .primary,
                        pronunciationColor: .primary.opacity(0.75)
                    )
                        .lineLimit(1)
                        .minimumScaleFactor(0.35)
                        .multilineTextAlignment(.center)
                    Text(word.translation)
                        .font(.caption2)
                        .lineLimit(2)
                        .minimumScaleFactor(0.4)
                        .multilineTextAlignment(.center)
                } else {
                    Text(word.russian)
                        .font(.headline.weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .multilineTextAlignment(.center)
                    Text(word.pronunciation)
                        .font(.caption2.italic())
                        .lineLimit(1)
                        .minimumScaleFactor(0.45)
                        .multilineTextAlignment(.center)
                    Text(word.translation)
                        .font(.caption2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.45)
                        .multilineTextAlignment(.center)
                }
            } else {
                Text("✓")
                    .font(.headline.weight(.bold))
                Text("done")
                    .font(.caption2)
            }
        }
        .widgetAccentable()
    }

    private var inlineContent: some View {
        Text(inlineText)
            .widgetAccentable()
    }

    private var inlineText: String {
        guard let word = entry.word else {
            return "Daily Russian: all words learned"
        }

        return "\(titleLine(for: word)) · \(word.translation)"
    }

    private func titleLine(for word: DailyRussianWord) -> String {
        "\(word.russian) • \(word.pronunciation)"
    }

    private func compactTitleLine(
        for word: DailyRussianWord,
        wordFont: Font,
        separatorFont: Font,
        pronunciationFont: Font,
        wordColor: Color,
        separatorColor: Color,
        pronunciationColor: Color
    ) -> some View {
        HStack(spacing: 0) {
            Text(word.russian)
                .font(wordFont)
                .foregroundStyle(wordColor)
            Text(" • ")
                .font(separatorFont)
                .foregroundStyle(separatorColor)
            Text(word.pronunciation)
                .font(pronunciationFont)
                .foregroundStyle(pronunciationColor)
        }
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

    private func dictionaryURL(for word: DailyRussianWord?) -> URL? {
        guard let word else { return nil }
        return URL(string: "dailyrussian://dictionary?rank=\(word.rank)")
    }
}

struct DailyWordWidget: Widget {
    let kind = "DailyWordWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyWordProvider()) { entry in
            DailyWordWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        colors: [
                            Color(red: 0.91, green: 0.35, blue: 0.37),
                            Color(red: 0.32, green: 0.11, blue: 0.13),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
        }
        .configurationDisplayName("Daily Russian Word")
        .description("Learn one new Russian word every day.")
        .supportedFamilies(supportedFamilies)
    }

    private var supportedFamilies: [WidgetFamily] {
        [
            .systemSmall,
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular,
        ]
    }
}

#Preview(as: .systemSmall) {
    DailyWordWidget()
} timeline: {
    DailyWordEntry(date: .now, word: DailyWordCatalog.words.first)
}

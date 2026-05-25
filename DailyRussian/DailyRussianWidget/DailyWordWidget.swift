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
        let entry = DailyWordEntry(date: now, word: store.wordForToday(now: now))
        completion(Timeline(entries: [entry], policy: .after(store.nextRefreshDate(after: now))))
    }
}

struct DailyWordWidgetView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    let entry: DailyWordEntry

    var body: some View {
        switch widgetFamily {
        case .accessoryInline:
            inlineContent
        case .accessoryCircular:
            circularContent
        default:
            stackedContent
        }
    }

    private var stackedContent: some View {
        VStack(alignment: .leading, spacing: 7) {
            if let word = entry.word {
                Text(word.russian)
                    .font(.title.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)

                Text(word.pronunciation)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.82))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                Text(word.shortMeaning)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.88))
                    .lineLimit(2)
                    .minimumScaleFactor(0.65)
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

    private var circularContent: some View {
        VStack(spacing: 2) {
            Text(entry.word?.russian ?? "✓")
                .font(.headline.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.45)
            Text(entry.word?.shortMeaning ?? "done")
                .font(.caption2)
                .lineLimit(1)
                .minimumScaleFactor(0.55)
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

        return "\(word.russian) • \(word.pronunciation) · \(word.shortMeaning)"
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
        .supportedFamilies([
            .systemSmall,
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular,
        ])
    }
}

#Preview(as: .systemSmall) {
    DailyWordWidget()
} timeline: {
    DailyWordEntry(date: .now, word: DailyWordCatalog.words.first)
}

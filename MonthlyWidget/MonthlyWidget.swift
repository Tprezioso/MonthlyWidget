//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Thomas Prezioso Jr on 1/2/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // Placeholder View
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }
    
    // Snapshot for Preview area
    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }

    // Request Frequency
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []

        // Generate a timeline consisting of 7 entries an day apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDay = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDay)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// Model
struct DayEntry: TimelineEntry {
    let date: Date
}

// View
struct MonthlyWidgetEntryView : View {
    var entry: DayEntry
    var config: MonthConfig
    
    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: entry.date)
    }

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(config.backgroundColor.gradient)
            VStack {
                HStack(spacing: 4) {
                    Text(config.emojiText)
                        .font(.title)
                    Text(entry.date.weekdayDisplayFormat)
                        .font(.title3)
                        .bold()
                        .minimumScaleFactor(0.6)
                        .foregroundColor(config.weekdayTextColor)
                    Spacer()
                }
                Text(entry.date.dayDisplayFormat)
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundColor(config.dayTextColor)
            }
            .padding()
        }
    }
}

// Widget
struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MonthlyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Monthly Style Widget")
        .description("The theme of the widget changes based on month!")
        .supportedFamilies([.systemSmall])
    }
}

struct MonthlyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyWidgetEntryView(entry: DayEntry(date: dateToDisplay(month: 11, day: 29)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
    
    static func dateToDisplay(month: Int, day: Int) -> Date {
        let components = DateComponents(
            calendar: Calendar.current,
            year: 2023,
            month: month,
            day: day
        )
        return Calendar.current.date(from: components)!
    }
}

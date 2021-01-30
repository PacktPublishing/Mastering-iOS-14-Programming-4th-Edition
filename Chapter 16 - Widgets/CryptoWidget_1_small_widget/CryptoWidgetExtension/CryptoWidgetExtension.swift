//
//  CryptoWidgetExtension.swift
//  CryptoWidgetExtension
//
//  Created by Mario Eguiluz on 10/01/2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  let coins = [Coin(id: 1, name: "Bitcoin", symbol: "BTC", quote: Quote(USD: QuoteData(price: 20000))), Coin(id: 1, name: "Litecoin", symbol: "LTC", quote: Quote(USD: QuoteData(price: 200)))]

  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), coins: coins)
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, coins: coins)
    completion(entry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration, coins: coins)
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let coins: [Coin]
}

struct CryptoWidgetExtensionEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    CoinDetail(coin: entry.coins[0])
  }
}

@main
struct CryptoWidgetExtension: Widget {
  let kind: String = "CryptoWidgetExtension"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
        CryptoWidgetExtensionEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
    .supportedFamilies([.systemSmall])
  }
}

struct CryptoWidgetExtension_Previews: PreviewProvider {
  static var previews: some View {
    CryptoWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), coins: [Coin(id: 1, name: "Bitcoin", symbol: "BTC", quote: Quote(USD: QuoteData(price: 20000))), Coin(id: 1, name: "Litecoin", symbol: "LTC", quote: Quote(USD: QuoteData(price: 200)))]))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}

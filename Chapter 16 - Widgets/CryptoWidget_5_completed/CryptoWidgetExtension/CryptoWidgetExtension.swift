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
  @ObservedObject var dataManager = DataManager()

  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), coins: dataManager.coins.data)
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, coins: dataManager.coins.data)
    completion(entry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    print("New Timeline \(Date())")
    dataManager.refresh { (coins) in
      let currentDate = Date()
      let futureDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
      let timeline = Timeline(entries: [SimpleEntry(date: Date(), configuration: configuration, coins: coins.data)], policy: .after(futureDate))
      completion(timeline)
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let coins: [Coin]
}

struct CryptoWidgetExtensionEntryView : View {
  var entry: Provider.Entry

  //1
  @Environment(\.widgetFamily) var family

  //2
  @ViewBuilder
  var body: some View {
    switch family {

    //3
    case .systemSmall where entry.coins.count > 0:
      switch entry.configuration.coinSelect {
      case .btc:
        CoinDetail(coin: entry.coins.filter { $0.symbol == "BTC" }.first!)
      case .ltc:
        CoinDetail(coin: entry.coins.filter { $0.symbol == "LTC" }.first!)
      case .eth:
        CoinDetail(coin: entry.coins.filter { $0.symbol == "ETH" }.first!)
      default:
        CoinDetail(coin: entry.coins.filter { $0.symbol == "BTC" }.first!)
      }

    //4
    case .systemMedium where entry.coins.count > 0:
      HStack(alignment: .center) {
        Spacer()
        CoinDetail(coin: entry.coins.first!)
        Spacer()
        CoinListView(data: entry.coins)
        Spacer()
      }

    //5
    default:
      PlaceholderView()
    }
  }
}

struct PlaceholderView : View {
  let coins = [Coin(id: 1, name: "Bitcoin", symbol: "BTC", quote: Quote(USD: QuoteData(price: 20000))), Coin(id: 1, name: "Litecoin", symbol: "LTC", quote: Quote(USD: QuoteData(price: 200)))]

    var body: some View {
      CryptoWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), coins: coins)).redacted(reason: .placeholder)
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
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}

struct CryptoWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        CryptoWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), coins: [Coin(id: 1, name: "Bitcoin", symbol: "BTC", quote: Quote(USD: QuoteData(price: 20000))), Coin(id: 1, name: "Litecoin", symbol: "LTC", quote: Quote(USD: QuoteData(price: 200)))]))
          .previewContext(WidgetPreviewContext(family: .systemSmall))
        PlaceholderView()
          .previewContext(WidgetPreviewContext(family: .systemSmall))
      }

      Group {
        CryptoWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), coins: [Coin(id: 1, name: "Bitcoin", symbol: "BTC", quote: Quote(USD: QuoteData(price: 20000))), Coin(id: 1, name: "Litecoin", symbol: "LTC", quote: Quote(USD: QuoteData(price: 200))), Coin(id: 1, name: "Ethereum", symbol: "ETH", quote: Quote(USD: QuoteData(price: 1200)))]))
          .previewContext(WidgetPreviewContext(family: .systemMedium))
        PlaceholderView()
          .previewContext(WidgetPreviewContext(family: .systemMedium))
      }
    }
}

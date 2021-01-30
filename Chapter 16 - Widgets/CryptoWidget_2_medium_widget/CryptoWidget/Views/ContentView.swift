//
//  ContentView.swift
//  CryptoWidget
//
//  Created by Mario Eguiluz on 24/12/2020.
//

import SwiftUI

struct ContentView: View {

  @ObservedObject var dataManager = DataManager()

  var body: some View {
    NavigationView {
      if dataManager.loading {
        Text("Loading...")
      } else {
        CoinListView(data: dataManager.coins.data)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CoinDetail(coin: Coin(id: 1, name: "Bitcoin", symbol: "BTC", quote: Quote(USD: QuoteData(price: 20000))))
      CoinRow(coin: Coin(id: 1, name: "Bitcoin", symbol: "BTC", quote: Quote(USD: QuoteData(price: 20000))))
    }
  }
}

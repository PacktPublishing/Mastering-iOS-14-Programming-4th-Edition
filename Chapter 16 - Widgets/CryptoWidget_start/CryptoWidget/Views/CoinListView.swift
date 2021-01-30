//
//  CoinListView.swift
//  CryptoWidget
//
//  Created by Mario Eguiluz on 25/12/2020.
//

import SwiftUI

struct CoinListView: View {
  var data: [Coin]

  var body: some View {
    VStack {
      ForEach(data, id: \.symbol){ coin in
        CoinRow(coin: coin)
      }
    }
  }
}

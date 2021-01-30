//
//  CoinRow.swift
//  CryptoWidget
//
//  Created by Mario Eguiluz on 04/01/2021.
//

import SwiftUI

struct CoinRow: View {
  var coin: Coin

  var body: some View {
    HStack {
      Text(coin.name)
      Text(coin.price)
    }
  }
}

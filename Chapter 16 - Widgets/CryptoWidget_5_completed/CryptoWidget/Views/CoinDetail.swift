//
//  CoinDetail.swift
//  CryptoWidget
//
//  Created by Mario Eguiluz on 04/01/2021.
//

import SwiftUI

struct CoinDetail: View {
  let coin: Coin
  var body: some View {
    VStack {
      Text(coin.name)
        .font(.title)
      Text(coin.price)
    }
    .navigationBarTitle(Text(coin.name), displayMode: .inline)
  }
}

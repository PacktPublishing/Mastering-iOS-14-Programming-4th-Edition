//
//  Coin.swift
//  CryptoWidget
//
//  Created by Mario Eguiluz on 24/12/2020.
//

import Foundation

struct Coin: Decodable, Identifiable {
  var id: Int
  var name: String
  var symbol: String
  var quote: Quote

  var price: String {
    return String(format: "$%.2f", quote.USD.price)
  }
}

struct Quote: Decodable {
  var USD: QuoteData
}

struct QuoteData: Decodable {
  var price: Double
}

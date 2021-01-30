//
//  DataManager.swift
//  CryptoWidget
//
//  Created by Mario Eguiluz on 24/12/2020.
//

import Foundation
import Combine

class DataManager: ObservableObject {

  @Published var coins = CoinList(data: [])
  @Published var loading = false

  private let apiKeyHeader = "X-CMC_PRO_API_KEY"
  private let apiKeyValue = "b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c"
  private let apiUrl = "https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=5&convert=USD"

  init() {
    loading = true
    getData()
  }

  private func getData() {
    guard let url = URL(string: apiUrl) else { return }
    var request = URLRequest(url: url)
    request.setValue(apiKeyValue, forHTTPHeaderField: apiKeyHeader)

    URLSession.shared.dataTask(with: request){ (data, _, _) in
      print("Update coins")
      guard let data = data else { return }
      let coins = try! JSONDecoder().decode(CoinList.self, from: data)
      DispatchQueue.main.async {
        print(coins)
        self.coins = coins
        self.loading = false
      }
    }.resume()
  }

  func refresh(completionHandler: @escaping (CoinList) -> Void) {
    guard let url = URL(string: apiUrl) else { return }
    var request = URLRequest(url: url)
    request.setValue(apiKeyValue, forHTTPHeaderField: apiKeyHeader)

    URLSession.shared.dataTask(with: request){ (data, _, _) in
      print("Update coins")
      guard let data = data else { return }
      let coins = try! JSONDecoder().decode(CoinList.self, from: data)
      DispatchQueue.main.async {
        print(coins)
        self.coins = coins
        self.loading = false

        completionHandler(coins)
      }
    }.resume()
  }
}

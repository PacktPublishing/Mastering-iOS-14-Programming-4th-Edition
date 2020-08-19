//
//  MovieDBResponse.swift
//  MustC
//
//  Created by Mario Eguiluz on 31/07/2020.
//  Copyright © 2020 DonnyWals. All rights reserved.
//

import Foundation

struct MovieDBLookupResponse: Codable {
  struct MovieDBMovie: Codable {
    let popularity: Double?
  }
  let results: [MovieDBMovie]
}

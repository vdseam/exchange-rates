//
//  ExchangeRate.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation

struct Currency {
    let index: Int // 0–200
    let code: String // USD
    let name: String // United States Dollar
    let symbol: String // $
    let value: Double // 44.40
    var isFavorite: Bool = false
}

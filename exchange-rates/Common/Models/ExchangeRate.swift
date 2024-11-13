//
//  ExchangeRate.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation

struct ExchangeRate: Identifiable {
    let id = UUID()
    let currency: String
    let rate: Double
    var isFavorite = false
}

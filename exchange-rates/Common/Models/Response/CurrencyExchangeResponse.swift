//
//  CurrencyExchangeResponse.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation

struct CurrencyExchangeResponse: Codable {
    let timestamp: TimeInterval
    let rates: [String: Double]
}

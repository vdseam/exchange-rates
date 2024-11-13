//
//  CurrencyNameResponse.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation

struct CurrencyNameResponse: Codable {
    let symbols: [String: String]
}

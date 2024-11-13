//
//  CurrencySymbolProvider.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation

protocol CurrencySymbolProviding {
    func symbol(for code: String) -> String
}

final class CurrencySymbolProvider: CurrencySymbolProviding {
    static let shared: CurrencySymbolProviding = CurrencySymbolProvider()
    private var symbols: [String: String] = [:]
    
    private init() {
        for identifier in Locale.availableIdentifiers {
            let locale = Locale(identifier: identifier)
            guard let currencyCode = locale.currency?.identifier,
                  let currencySymbol = locale.currencySymbol else {
                continue
            }
            if symbols[currencyCode] == nil {
                symbols[currencyCode] = currencySymbol
            } else if let cachedSymbol = symbols[currencyCode],
                      !currencySymbol.isEmpty,
                      currencySymbol.count < cachedSymbol.count {
                symbols[currencyCode] = currencySymbol
            }
        }
    }
    
    func symbol(for code: String) -> String {
        symbols[code] ?? code
    }
}

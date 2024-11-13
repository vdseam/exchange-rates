//
//  CurrencySymbolProvider.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation

struct CurrencySymbolProvider {
    let code: String
    let symbols: [String]
    
    var shortestSymbol: String {
        symbols.min { $0.count < $1.count } ?? ""
    }
    
    static fileprivate var cache: [String: CurrencySymbolProvider] = { () -> [String: CurrencySymbolProvider] in
        var mapCurrencyCode2Symbols: [String: Set<String>] = [:]
        let currencyCodes = Set(Locale.commonISOCurrencyCodes)
        
        for localeId in Locale.availableIdentifiers {
            let locale = Locale(identifier: localeId)
            guard let currencyCode = locale.currencyCode, let currencySymbol = locale.currencySymbol else {
                continue
            }
            if currencyCode.contains(currencyCode) {
                mapCurrencyCode2Symbols[currencyCode, default: []].insert(currencySymbol)
            }
        }
        
        var mapCurrencyCode2Currency: [String: CurrencySymbolProvider] = [:]
        for (code, symbols) in mapCurrencyCode2Symbols {
            mapCurrencyCode2Currency[code] = CurrencySymbolProvider(code: code, symbols: Array(symbols))
        }
        return mapCurrencyCode2Currency
    }()
    
    static func currency(for code: String) -> CurrencySymbolProvider? {
        cache[code]
    }
}

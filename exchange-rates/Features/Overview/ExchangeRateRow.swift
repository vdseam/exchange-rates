//
//  ExchangeRateRow.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import SwiftUI

struct ExchangeRateRow: View {
    let currency: Currency
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(currency.name)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Text("\(currency.index)")
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(.primary.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 6))
                    
                    Text(currency.code)
                        .foregroundStyle(.secondary)
                }
                .font(.system(size: 14, weight: .medium))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                // CurrencySymbolProvider.currency(for: symbol)?.shortestSymbol ?? symbol
                Text(String(format: "%@%.2f", currency.symbol, currency.value))
                    .font(.headline)
                
                if currency.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.orange)
                        .font(.system(size: 14, weight: .medium))
                }
            }
        }
    }
}

struct RedactedExchangeRateRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("United States Dollar")
                    .font(.headline)
                    .redacted(reason: .placeholder)
                
                Spacer()
                
                Text("ALL00.00")
                    .font(.headline)
                    .redacted(reason: .placeholder)
            }
            
            HStack(spacing: 6) {
                Text("\(0)")
                    .redacted(reason: .placeholder)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(.primary.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 6))
                
                Text("USD")
                    .foregroundStyle(.secondary)
                    .redacted(reason: .placeholder)
            }
            .font(.system(size: 14, weight: .medium))
        }
    }
}

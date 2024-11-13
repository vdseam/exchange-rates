//
//  ExchangeRateRow.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import SwiftUI

struct ExchangeRateRow: View {
    let symbol: String
    let description: String
    let value: Double
    let index: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(description)
                    .font(.headline)
                
                HStack(spacing: 6) {
                    Text("\(index)")
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(.primary.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 6))
                    
                    Text(symbol)
                        .foregroundStyle(.secondary)
                }
                .font(.system(size: 14, weight: .medium))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text(String(format: "%@%.2f", CurrencySymbolProvider.currency(for: symbol)?.shortestSymbol ?? symbol, value))
                    .font(.headline)
                
                Image(systemName: "star.fill")
                    .foregroundStyle(.orange)
                    .font(.system(size: 14, weight: .medium))
                    .opacity(Bool.random() ? 0 : 1)
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

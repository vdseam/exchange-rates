//
//  CurrencyViewModel.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Combine
import Foundation

final class CurrencyViewModel: ObservableObject {
    private let storage: CurrencyStorage
    private let repository: CurrencyRepository
    
    @Published var searchText = String()
    @Published private var rates: [Currency] = []
    @Published private(set) var isLoading = false
    
    @Published private(set) var error: String?
    @Published var isErrorPresented = false
    
    @Published var isFiltered = false
    @Published private(set) var updatedAt = String()
    @Published var baseCurrencyCode = UserDefaults.baseCurrencyCode
    
    private var currencyNames: [String: String] = [:]
    private var cancellable: Set<AnyCancellable> = []
    
    var searchResults: [Currency] {
        var results = rates
        if isFiltered {
            results = results.filter { $0.isFavorite }
        }
        if searchText.isEmpty {
            return results
        } else {
            return results.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    // MARK: - Initializer
    
    init(storage: CurrencyStorage = LocalCurrencyStorage(),
         repository: CurrencyRepository = RemoteCurrencyRepository()) {
        self.storage = storage
        self.repository = repository
        bind()
    }
    
    // MARK: - Bindings
    
    private func bind() {
        $baseCurrencyCode
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { baseCurrencyCode in
                UserDefaults.baseCurrencyCode = baseCurrencyCode
                // FIXME: - Euro is the only base currency available for free
                // fetchAndCacheRemoteRates()
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Cache & Networking
    
    func fetch() {
        if let timestamp = UserDefaults.timestamp {
            formatTimestamp(timestamp)
        }
        fetchCachedRates()
    }
    
    private func fetchCachedRates() {
        isLoading = true
        let cachedRates = storage.fetchCurrencies()
        if cachedRates.isEmpty {
            Task { @MainActor in
                let response = try await repository.getCurrencyNames()
                currencyNames = response.symbols
                fetchAndCacheRemoteRates()
            }
        } else {
            rates = cachedRates
            isLoading = false
            fetchAndCacheRemoteRates()
        }
    }
    
    private func fetchAndCacheRemoteRates() {
        if rates.isEmpty {
            isLoading = true
        }
        Task { @MainActor in
            do {
                // We may request only the filtered currencies,
                // but it be inconvenient to update the list partially.
                let response = try await repository.getLatestRates(
                    baseCurrencyCode: baseCurrencyCode
                )
                updateAndFormatTimestamp(response.timestamp)
                let symbolProvider: CurrencySymbolProviding = CurrencySymbolProvider.shared
                
                var i = 0
                for (key, value) in response.rates.sorted(by: { $0.key < $1.key }) {
                    let symbol = symbolProvider.symbol(for: key)
                    updateOrAppendCurrency(index: i, code: key, symbol: symbol, value: value)
                    i += 1
                }
                storage.saveCurrencies(rates)
            } catch {
                self.error = error.localizedDescription
                isErrorPresented = true
            }
            isLoading = false
        }
    }
    
    private func updateOrAppendCurrency(index: Int, code: String, symbol: String, value: Double) {
        if let index = rates.firstIndex(where: { $0.code == code }) {
            rates[index].value = value
        } else {
            let currency = Currency(
                index: index,
                code: code,
                name: currencyNames[code] ?? String(),
                symbol: symbol,
                value: value
            )
            rates.append(currency)
        }
    }
    
    func toggleFavorite(for currency: Currency) {
        rates[currency.index].isFavorite.toggle()
        storage.toggleFavorite(for: currency.code)
    }
    
    // MARK: - Date Formatter
    
    private func updateAndFormatTimestamp(_ timestamp: TimeInterval) {
        UserDefaults.timestamp = timestamp
        formatTimestamp(timestamp)
    }
    
    private func formatTimestamp(_ timestamp: TimeInterval) {
        let date = Date(timeIntervalSince1970: timestamp)
        if Calendar.current.isDateInToday(date) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateStyle = DateFormatter.Style.none
            dateFormatter.timeZone = .current
            updatedAt = "at \(dateFormatter.string(from: date))"
        } else if Calendar.current.isDateInYesterday(date) {
            updatedAt = "Yesterday"
        } else {
            updatedAt = "a Long Time Ago"
        }
    }
}

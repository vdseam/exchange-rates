//
//  CurrencyViewModel.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Combine

class CurrencyViewModel: ObservableObject {
    private let repository: CurrencyRepository
    
    @Published private(set) var rates: [String: Double] = [:]
    @Published private(set) var isLoading = false
    
    @Published var searchText = String()
    @Published var baseCurrencyCode = "EUR"
    @Published var isFiltered = false
    
    var searchResults: [String: Double] {
        // TODO: - Optimize the search by both title and code
        if searchText.isEmpty {
            return rates
        } else {
            return rates.filter { $0.key.contains(searchText) }
        }
    }
    
    init(repository: CurrencyRepository = MockCurrencyRepository()) {
        self.repository = repository
    }
    
    func fetch() {
        isLoading = true
        Task { @MainActor in
            do {
                let response = try await repository.getLatestRates(baseCurrencyCode: "EUR")
                rates = response.rates
            } catch {
                print(error.localizedDescription)
            }
            isLoading = false
        }
    }
}

//
//  CurrencyRepositoryTests.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import XCTest
@testable import exchange_rates

final class MockCurrencyRepositoryTests: XCTestCase {
    private var repository: MockCurrencyRepository!

    override func setUp() {
        super.setUp()
        repository = MockCurrencyRepository()
    }

    override func tearDown() {
        repository = nil
        super.tearDown()
    }

    func testGetLatestRatesSuccess() async throws {
        // Given
        let expectedBaseCurrency = "EUR"
        let expectedRatesCount = 171
        
        // When
        let response = try await repository.getLatestRates(baseCurrencyCode: expectedBaseCurrency)
        
        // Then
        XCTAssertEqual(response.rates.count, expectedRatesCount, "Rates count does not match expected count")
    }
    
    func testGetCurrencyNamesSuccess() async throws {
        // When
        let response = try await repository.getCurrencyNames()
        
        // Then
        XCTAssertEqual(response.symbols.count, 171, "Symbols count does not match expected count")
    }
}

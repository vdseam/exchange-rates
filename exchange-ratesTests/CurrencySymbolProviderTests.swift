//
//  CurrencySymbolProviderTests.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import XCTest
@testable import exchange_rates

final class CurrencySymbolProviderTests: XCTestCase {
    var currencySymbolProvider: CurrencySymbolProviding!
    
    override func setUp() {
        super.setUp()
        currencySymbolProvider = CurrencySymbolProvider.shared
    }
    
    override func tearDown() {
        currencySymbolProvider = nil
        super.tearDown()
    }
    
    func testSymbolForCommonCurrencyCode_USD() {
        let usdSymbol = currencySymbolProvider.symbol(for: "USD")
        XCTAssertEqual(usdSymbol, "$", "Expected $ symbol for USD")
    }
    
    func testSymbolForCommonCurrencyCode_EUR() {
        let eurSymbol = currencySymbolProvider.symbol(for: "EUR")
        XCTAssertEqual(eurSymbol, "€", "Expected € symbol for EUR")
    }
    
    func testSymbolForCommonCurrencyCode_GBP() {
        let gbpSymbol = currencySymbolProvider.symbol(for: "GBP")
        XCTAssertEqual(gbpSymbol, "£", "Expected £ symbol for GBP")
    }
    
    func testSymbolForInvalidCurrencyCode() {
        let invalidCode = "XYZ"
        let symbol = currencySymbolProvider.symbol(for: invalidCode)
        XCTAssertEqual(symbol, "XYZ", "Expected fallback to currency code itself for invalid code")
    }
    
    func testSymbolForEmptyCurrencyCode() {
        let emptySymbol = currencySymbolProvider.symbol(for: "")
        XCTAssertEqual(emptySymbol, "", "Expected empty string for empty currency code")
    }
    
    func testSymbolForNonAlphabeticCurrencyCode() {
        let nonAlphabeticSymbol = currencySymbolProvider.symbol(for: "123")
        XCTAssertEqual(nonAlphabeticSymbol, "123", "Expected fallback to currency code for non-alphabetic input")
    }
    
    func testSymbolForSingleCharacterCurrencyCode() {
        let singleCharSymbol = currencySymbolProvider.symbol(for: "X")
        XCTAssertEqual(singleCharSymbol, "X", "Expected fallback to currency code for single character code")
    }
    
    func testSymbolForWhitespaceCurrencyCode() {
        let whitespaceSymbol = currencySymbolProvider.symbol(for: " ")
        XCTAssertEqual(whitespaceSymbol, " ", "Expected fallback to currency code for whitespace")
    }
    
    func testSingletonInstance() {
        let anotherInstance = CurrencySymbolProvider.shared
        XCTAssertTrue(currencySymbolProvider === anotherInstance, "Expected shared instance to be singleton")
    }
    
    func testFallbackToCodeForMissingCurrencySymbol() {
        let unknownCode = "BTC" // Assuming BTC is not in the Locale list
        let symbol = currencySymbolProvider.symbol(for: unknownCode)
        XCTAssertEqual(symbol, "BTC", "Expected fallback to code itself for unmapped currency code")
    }
}

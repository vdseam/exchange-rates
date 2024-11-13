//
//  CurrencyRepository.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation

protocol CurrencyRepository {
    func getLatestRates(baseCurrencyCode: String) async throws -> CurrencyExchangeResponse
    func getCurrencyNames() async throws -> CurrencyNameResponse
}

final class RemoteCurrencyRepository: CurrencyRepository {
    private let baseURL = URL(string: "http://data.fixer.io/api")
    
    func getLatestRates(baseCurrencyCode: String) async throws -> CurrencyExchangeResponse {
        guard let request = request(to: "latest", customQueryItems: [
            URLQueryItem(name: "base", value: baseCurrencyCode)
        ]) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(CurrencyExchangeResponse.self, from: data)
    }
    
    func getCurrencyNames() async throws -> CurrencyNameResponse {
        guard let request = request(to: "symbols") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(CurrencyNameResponse.self, from: data)
    }
    
    func request(to path: String, customQueryItems: [URLQueryItem] = []) -> URLRequest? {
        guard var url = URL(string: path, relativeTo: baseURL) else { return nil }
        url.append(queryItems: [URLQueryItem(name: "access_key", value: Environment.apiKey)])
        url.append(queryItems: customQueryItems)
        return URLRequest(url: url)
    }
}

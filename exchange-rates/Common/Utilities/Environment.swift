//
//  Environment.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation

enum Environment {
    enum Keys {
        static let apiKey = "API_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Property list file not found.")
        }
        return dict
    }()
    
    static let apiKey: String = {
        guard let value = Self.infoDictionary[Keys.apiKey] as? String else {
            fatalError("API key not set in property list.")
        }
        return value
    }()
}

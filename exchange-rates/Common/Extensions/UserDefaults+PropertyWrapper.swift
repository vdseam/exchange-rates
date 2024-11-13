//
//  UserDefaults+PropertyWrapper.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
        }
    }

    var projectedValue: Bool {
        return true
    }
}

extension UserDefaults {
    @UserDefault(key: "timestamp", defaultValue: nil)
    static var timestamp: TimeInterval?
    
    @UserDefault(key: "base_currency_code", defaultValue: "EUR")
    static var baseCurrencyCode: String
}

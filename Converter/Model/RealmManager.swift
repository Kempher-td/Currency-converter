//
//  DefaultsManager.swift
//  Converter
//
//  Created by Victor Mashukevich on 18.11.24.
//
import Foundation

struct UserDefaultsKeys {
    static let exchangeRates = "exchangeRates"
}

class DefaultsManager {
    private let defaults = UserDefaults.standard
    

    func saveExchangeRates(_ rates: [String: Double]) {
        defaults.set(rates, forKey: UserDefaultsKeys.exchangeRates)
    }
    

    func loadExchangeRates() -> [String: Double] {
        return defaults.dictionary(forKey: UserDefaultsKeys.exchangeRates) as? [String: Double] ?? [:]
    }
}


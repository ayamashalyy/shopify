//
//  SettingsViewModel.swift
//  Shopify
//
//  Created by Rawan Elsayed on 11/06/2024.
//

import Foundation

class SettingsViewModel{
    
    enum CurrencySelected: String {
        case USD
        case EGP
    }
    
    enum NetworkError: Error {
        case noData
        case invalidData
        case decodingError
        case other(Error)
    }
    
    let currencyKey = "selectedCurrency"
    var currencyConversionRates: [String: Double] = [:]
    let urlString = "https://v6.exchangerate-api.com/v6/b8bdb1874a7d78bef8610486/latest/EGP"
    
    // save the selected currency to UserDefaults
    func saveCurrencySelection(_ currency: CurrencySelected) {
        UserDefaults.standard.set(currency.rawValue, forKey: currencyKey)
    }
    
    // retrieve the selected currency from UserDefaults
    func getSelectedCurrency() -> CurrencySelected? {
        if let currencyString = UserDefaults.standard.string(forKey: currencyKey) {
            return CurrencySelected(rawValue: currencyString)
        }
        return nil
    }
    
    func fetchExchangeRates(completion: @escaping (Error?) -> Void) {
        NetworkManager.fetchExchangeRates(urlString: urlString) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            }
            guard let data = data else {
                completion(NetworkError.noData)
                return
            }
            Decoding.decodeData(data: data, objectType: Currency.self) { currency, error in
                if let error = error {
                    completion(error)
                    return
                }
                if let currency = currency {
                    self.setCurrencyConversionRates(currency.conversion_rates)
                    completion(nil)
                }
            }
        }
    }
    
    // Set currency conversion rates
    private func setCurrencyConversionRates(_ rates: [String: Double]) {
        currencyConversionRates = rates
    }
    
    func convertPrice(_ price: String, to currency: CurrencySelected) -> String? {
        let conversionRates = currencyConversionRates
        guard let conversionRate = conversionRates[currency.rawValue] else {
            return nil
        }
        
        guard let priceDouble = Double(price) else {
            return nil
        }
        
        let convertedPrice = priceDouble * conversionRate
        return String(format: "%.2f %@", convertedPrice, currency.rawValue)
    }
}

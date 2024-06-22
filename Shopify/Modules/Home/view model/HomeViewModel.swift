//
//  HomeViewModel.swift
//  Shopify
//
//  Created by aya on 02/06/2024.
//

import Foundation

class HomeViewModel {
    var brands: [Brand] = []
    var discountCodes: [DiscountCode] = []
    var priceRules: [PriceRule] = []
    var cartItemsCount = 0
    
    private let reachabilityChecker: CheckNetworkReachability.Type
    
    init(reachabilityChecker: CheckNetworkReachability.Type = CheckNetworkReachability.self) {
        self.reachabilityChecker = reachabilityChecker
    }
    
    func isNetworkReachable() -> Bool {
        return reachabilityChecker.checkNetworkReachability()
    }
    
    func fetchBrands(completion: @escaping (Error?) -> Void) {
        
        NetworkManager.fetchDataFromApi(endpoint: .smartCollections, rootOfJson:.smartCollectionsRoot) { data, error in
            guard let data = data, error == nil else {
                completion(error)
                return
            }
            
            Decoding.decodeData(data: data, objectType: [Brand].self) { [weak self] (brands, decodeError) in
                guard let self = self else { return }
                if let brands = brands {
                    self.brands = brands
                    completion(nil)
                } else if let decodeError = decodeError {
                    completion(decodeError)
                } else {
                    completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
    
    func numberOfBrands() -> Int {
        return brands.count
    }
    
    func brand(at index: Int) -> Brand? {
        guard index >= 0 && index < brands.count else {
            return nil
        }
        return brands[index]
    }
    
    func fetchDiscountCodes(completion: @escaping (Error?) -> Void) {
        guard !priceRules.isEmpty else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No price rules available"]))
            return
        }
        
        discountCodes.removeAll() // Clear existing discount codes
        
        var errorOccurred = false
        let group = DispatchGroup()
        
        for priceRule in priceRules {
            group.enter()
            
            let endpoint = Endpoint.discount_code
            let addition = "/\(priceRule.id)/discount_codes.json?limit=1"
            
            NetworkManager.fetchDataFromApi(endpoint: endpoint, rootOfJson: .discountCodes, addition: addition) { [weak self] data, error in
                defer { group.leave() }
                guard let self = self, let data = data, error == nil else {
                    if !errorOccurred {
                        errorOccurred = true
                        completion(error)
                    }
                    return
                }
                
                Decoding.decodeData(data: data, objectType: [DiscountCode].self) { discountCodes, decodeError in
                    if let discountCode = discountCodes?.first {
                        self.discountCodes.append(discountCode)
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            if !errorOccurred {
                completion(nil)
            }
        }
    }
    func discountCode(at index: Int) -> DiscountCode? {
        guard index >= 0 && index < discountCodes.count else {
            return nil
        }
        return discountCodes[index]
    }
    
    // Function to fetch price rules and store their IDs
    func priceRule(at index: Int) -> PriceRule? {
        guard index >= 0 && index < priceRules.count else {
            return nil
        }
        return priceRules[index]
    }
    
        
   
    
    func getShoppingCartItemsCount(completion: @escaping (Int?, Error?) -> Void)
    {
        NetworkManager.getShoppingCartItemsCount(completion: completion)
    }
    
    
    
    func fetchPriceRules(completion: @escaping (Error?) -> Void) {
        NetworkManager.fetchDataFromApi(endpoint: .discount_code, rootOfJson: .priceRules, addition: ".json") { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                completion(error)
                return
            }
            
            Decoding.decodeData(data: data, objectType: [PriceRule].self) { priceRules, decodeError in
                if let priceRules = priceRules {
                    self.priceRules = priceRules
                    completion(nil)
                } else if let decodeError = decodeError {
                    completion(decodeError)
                } else {
                    completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
    
    // Method to store discount code and price rule value in UserDefaults as a dictionary
     func storeDiscountCodeWithPriceRule(code: String, priceRuleValue: Int) {
         let discountDict = ["code": code, "priceRuleValue": priceRuleValue] as [String : Any]
         UserDefaults.standard.set(discountDict, forKey: "storedDiscountCode")
     }
     
     // Method to fetch stored discount code and price rule value from UserDefaults
     func fetchStoredDiscountCode() -> [String: Any]? {
         guard let storedDiscountDict = UserDefaults.standard.dictionary(forKey: "storedDiscountCode") else {
             return nil
         }
         return storedDiscountDict
     }
}

enum PriceRuleValue: Int {
    case minus20 = 20
    case minus25 = 25
    case minus30 = 30
    
    // Method to convert a string value to the corresponding enum case
    static func fromString(_ value: String) -> PriceRuleValue? {
        switch value {
        case "-20.0":
            return .minus20
        case "-25.0":
            return .minus25
        case "-30.0":
            return .minus30
        default:
            return nil
        }
    }
}


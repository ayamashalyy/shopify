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
        NetworkManager.fetchDataFromApi(endpoint: .discount_code, rootOfJson: .discountCodes) { data, error in
            guard let data = data, error == nil else {
                completion(error)
                return
            }

            Decoding.decodeData(data: data, objectType: [DiscountCode].self) { [weak self] (discountCodes, decodeError) in
                guard let self = self else { return }
                if let discountCodes = discountCodes {
                    self.discountCodes = discountCodes
                    completion(nil)
                } else if let decodeError = decodeError {
                    completion(decodeError)
                } else {
                    completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
    func discountCode(at index: Int) -> DiscountCode? {
        guard index >= 0 && index < discountCodes.count else {
            return nil
        }
        return discountCodes[index]
    }
}


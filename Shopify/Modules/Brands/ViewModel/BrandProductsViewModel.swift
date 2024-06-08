//
//  BrandProductsViewModel.swift
//  Shopify
//
//  Created by Rawan Elsayed on 08/06/2024.
//

import Foundation

class BrandProductsViewModel{
    
    var products: [Product] = []
    private var collectionId: Int?
    
    func setCollectionId(_ id: Int) {
        self.collectionId = id
    }
    
    func fetchProducts(completion: @escaping (Error?) -> Void) {
        
        guard let collectionId = collectionId else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Collection ID is nil"]))
            return
        }
        
        let additionalParams = "\(collectionId)"
            
        NetworkManager.fetchDataFromApi(endpoint: .listOfBrandProducts, rootOfJson: .products, addition: additionalParams) { data, error in
            guard let data = data, error == nil else {
                completion(error)
                return
            }
                
            Decoding.decodeData(data: data, objectType: [Product].self) { [weak self] (products, decodeError) in
                guard let self = self else { return }
                if let products = products {
                    self.products = products
                    completion(nil)
                } else if let decodeError = decodeError {
                    completion(decodeError)
                } else {
                    completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
        
    func numberOfProducts() -> Int {
        return products.count
    }

    func product(at index: Int) -> Product? {
        guard index >= 0 && index < products.count else {
            return nil
        }
        return products[index]
    }
}

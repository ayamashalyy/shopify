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
    var filteredProducts: [Product] = []
    
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
                    self.filteredProducts = products
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
        return filteredProducts.count
    }

    func product(at index: Int) -> Product? {
        guard index >= 0 && index < filteredProducts.count else {
            return nil
        }
        return filteredProducts[index]
    }
    
    func filterProducts(byPrice price: Float) {
        filteredProducts = products.filter { product in
            if let priceString = product.variants.first?.price, let priceValue = Float(priceString) {
                print("Comparing product price: \(priceValue) with filter price: \(price)")
                return priceValue <= price
            }
            return false
        }
        print("Filtered products count: \(filteredProducts.count)")  
    }
}

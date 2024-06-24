//
//  CategoriesViewModel.swift
//  Shopify
//
//  Created by Rawan Elsayed on 10/06/2024.
//

import Foundation

class CategoriesViewModel{
    
    var categoryProducts: [Product] = []
    var allProducts: [Product] = []
    
    func fetchCategoryProducts(_ categoryId: CategoryId, _ productType: ProductType ,completion: @escaping (Error?) -> Void) {
        
        let categoryId = categoryId.id
        let productType = productType.type
        
        let additionalParams = "\(categoryId)&product_type=\(productType)"
        
        let urlString = "https://\(API_KEY):\(TOKEN)\(baseUrl)\(Endpoint.listOfBrandProducts.rawValue)\(additionalParams)"
        print("Request URL: \(urlString)")
        
        
        NetworkManager.fetchDataFromApi(endpoint: .listOfBrandProducts, rootOfJson:.products, addition: additionalParams) { data, error in
            guard let data = data, error == nil else {
                completion(error)
                return
            }
            
            Decoding.decodeData(data: data, objectType: [Product].self) { [weak self] (products, decodeError) in
                guard let self = self else { return }
                if let products = products {
                  
                    if Authorize.isRegistedCustomer(){
                        
                        self.checkIsFav(productFromApi: products) { productWithFavStatus in
                            self.categoryProducts = productWithFavStatus
                            completion(nil)
                        }
                        
                    }else {
                        self.categoryProducts = products
                        completion(nil)
                    }
                    
                } else if let decodeError = decodeError {
                    completion(decodeError)
                } else {
                    completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
    
    
    func getShoppingCartItemsCount(completion: @escaping (Int?, Error?) -> Void)
    {
        GetShoppingCartItemsCount.getShoppingCartItemsCount(completion: completion)
    }
    
    
    
    func checkIsFav(productFromApi: [Product], completion: @escaping ([Product]) -> Void) {
        var favViewModel = FavViewModel()
        favViewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let lineItems = favViewModel.LineItems else {
                    completion(productFromApi)
                    return
                }
                
                let favoriteVariantIds = lineItems.compactMap { $0.variant_id }
                
                let updatedProducts = productFromApi.map { product -> Product in
                    var updatedProduct = product
                    if let variantId = product.variants.first?.id {
                                       if favoriteVariantIds.contains(variantId) && variantId != fakeProductInDraftOrder {
                                           updatedProduct.variants[0].isSelected = true
                                       }
                                   }
                    return updatedProduct
                }
                
                completion(updatedProducts)
            }
        }
        favViewModel.getFavs()
    }
    
    
    
    
    
    func numberOfCategoryProducts() -> Int {
        return categoryProducts.count
    }
    
    func product(at index: Int) -> Product? {
        guard index >= 0 && index < categoryProducts.count else {
            return nil
        }
        return categoryProducts[index]
    }
    
    func fetchAllProducts(completion: @escaping (Error?) -> Void) {
        
        NetworkManager.fetchDataFromApi(endpoint: .allProduct, rootOfJson:.products) { data, error in
            guard let data = data, error == nil else {
                completion(error)
                return
            }
            
            Decoding.decodeData(data: data, objectType: [Product].self) { [weak self] (allProducts, decodeError) in
                guard let self = self else { return }
                if let allProducts = allProducts {
                    self.allProducts = allProducts
                    completion(nil)
                } else if let decodeError = decodeError {
                    completion(decodeError)
                } else {
                    completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
    
    func numberOfAllProducts() -> Int {
        return allProducts.count
    }
    
    func allProducts(at index: Int) -> Product? {
        guard index >= 0 && index < allProducts.count else { return nil }
        return allProducts[index]
    }
    
    func findProductInAllProducts(by id: String) -> Product? {
        return allProducts.first { "\($0.id)" == id }
    }
    
}

enum CategoryId: Int {
    case men = 429707493624
    case women = 429707526392
    case kids = 429707559160
    case sale = 429707591928
    
    var id: Int {
        return self.rawValue
    }
}

enum ProductType: String {
    case shoes = "SHOES"
    case accessories = "ACCESSORIES"
    case t_shirt = "T-SHIRTS"
    case all = ""
    
    var type: String {
        return self.rawValue
    }
}

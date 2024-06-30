//
//  BrandProductsViewModel.swift
//  Shopify
//
//  Created by Rawan Elsayed on 08/06/2024.
//

import Foundation

class BrandProductsViewModel{

        var products: [Product] = []
        var favViewModel = FavViewModel()
        private var collectionId: String?
        var filteredProducts: [Product] = []

        func setCollectionId(_ id: String) {
            self.collectionId = id
        }

        func fetchProducts(completion: @escaping (Error?) -> Void) {
            guard let collectionId = collectionId else {
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Collection ID is nil"]))
                return
            }
            
            let additionalParams = "\(collectionId)"
            print("additionalParams\(additionalParams) ")
            NetworkManager.fetchDataFromApi(endpoint: .listOfBrandProducts, rootOfJson: .products, addition: additionalParams) { [weak self] data, error in
                guard let self = self else { return }
                guard let data = data, error == nil else {
                    completion(error)
                    return
                }

                Decoding.decodeData(data: data, objectType: [Product].self) { products, decodeError in
                    if let products = products {
                        
                        if Authorize.isRegistedCustomer(){
                            self.checkIsFav(productFromApi: products) { productWithFavStatus in
                                self.products = productWithFavStatus
                                self.filteredProducts = productWithFavStatus
                                completion(nil)
                            }
                        }else {
                            self.products = products
                            self.filteredProducts = products
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

        func checkIsFav(productFromApi: [Product], completion: @escaping ([Product]) -> Void) {
            favViewModel.bindResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self, let lineItems = self.favViewModel.LineItems else {
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

//
//  SearchViewModel.swift
//  Shopify
//
//  Created by mayar on 07/06/2024.
//
//
import Foundation

class SearchViewModel {
    
    var favViewModel = FavViewModel()
    var bindResultToViewController: (() -> Void) = {}
    
    var products: [Product]? {
        didSet {
            self.bindResultToViewController()
        }
    }
    
    var recevingProductFromANotherScreen : [Product]?
    
    
    func getProducts() {
        NetworkManager.fetchDataFromApi(endpoint: .allProduct, rootOfJson: .products) { data, error in
            guard let data = data, error == nil else {
                print("Error in data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            print("calll")
            Decoding.decodeData(data: data, objectType: [Product].self) { [weak self] (products, decodeError) in
                guard let self = self else { return }
                if let products = products {
                    
                    if Authorize.isRegistedCustomer() {
                        self.checkIsFav(productFromApi: products) { productWithFavStatus in
                            self.products = productWithFavStatus
                        }
                    } else {
                        self.products = products
                    }
                    
                } else if let decodeError = decodeError {
                    print("Decoding error: \(decodeError.localizedDescription)")
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
    
    func filterProducts(filteredProducts: [Product], byPrice price: Float) -> [Product] {
        let filtered = filteredProducts.filter { product in
            if let priceString = product.variants.first?.price, let priceValue = Float(priceString) {
                print("Comparing product price: \(priceValue) with filter price: \(price)")
                return priceValue <= price
            }
            return false
        }
        print("Filtered products count: \(filtered.count)")
        return filtered
    }
}

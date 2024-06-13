//
//  SearchViewModel.swift
//  Shopify
//
//  Created by mayar on 07/06/2024.
//

import Foundation

class SearchViewModel {
    
    var bindResultToViewController: (() -> Void) = {}
    
    var products: [Product]? {
        didSet {
                self.bindResultToViewController()
        }
    }
    
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
                    self.products = products
                    print("prducts is comed")
                    for product in products {
                        print("prducts is \(product.name)")

                    }
                } else if let decodeError = decodeError {
                    print("Decoding error: \(decodeError.localizedDescription)")
                }
            }
        }
    }
}

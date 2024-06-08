//
//  ProductViewModel.swift
//  Shopify
//
//  Created by mayar on 07/06/2024.
//

import Foundation

class ProductViewModel{
    
    var bindResultToViewController : (()->()) = {}
    
    var product : Product?{
        didSet{
            bindResultToViewController()
        }
    }
    
    func getProductDetails(id: String) {
        
        // static id insted of take it from parmeter
       //  let addition = "\(id).json"
              
        NetworkManager.fetchDataFromApi(endpoint: .specificProduct, rootOfJson: .product, addition: "8575847989496.json") { data , error in
            guard let data = data, error == nil else {
                print("error in data")
                return
            }
            
            Decoding.decodeData(data: data, objectType: Product.self) { [weak self] (product, decodeError) in
                guard let self = self else { return }
                if let product = product {
                    self.product = product
                }
                
            }
        }
    }
    
        static func getReviews() -> [(String, String)] {
            return ProductReviews.getReviews()
    }

}

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
            
            let addition = "\(id).json"
            NetworkManager.fetchDataFromApi(endpoint: .specificProduct, rootOfJson: .product, addition: addition) { data , error in
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

    
    func addToCartDraftOrders(selectedVariantsData: [(id: Int, imageUrl: String)]) {
        //        // here i want first get draft order

        // here i want first get draft order

        for data in selectedVariantsData {
              print("Adding to cart with ID: \(data.id) and Image URL: \(data.imageUrl)")
            //        // add new item for this id . every id with quantity 1

          }
          // call to update
      }
    
    
    
    func addToFavDraftOrders() {
        
        
    }

        
            static func getReviews() -> [(String, String, String)] {
                return UserReview.getReviews()
        }

    }

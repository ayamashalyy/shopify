//
//  FavViewModel.swift
//  Shopify
//
//  Created by mayar on 11/06/2024.
//

import Foundation

class FavViewModel {
   
    var bindResultToViewController : (()->()) = {}
    
    var LineItems : [LineItem]?{
        didSet{
            bindResultToViewController()
        }
    }
    
    func getFavs() {
        let addition = "\(Authorize.favDraftOrder()!).json"
        
        NetworkManager.fetchDataFromApi(endpoint: .specficDraftOeder, rootOfJson: .specificDraftOrder, addition: addition) { data , error in
            guard let data = data, error == nil else {
                print("error in data")
                return
            }
            
            Decoding.decodeData(data: data, objectType: DraftOrder.self) { [weak self] (draftOrder, decodeError) in
                guard let self = self else { return }
                if let draftOrder = draftOrder {
                    self.LineItems = draftOrder.line_items

                }
            }
        }
    }
}

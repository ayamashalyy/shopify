//
//  ShoppingCartViewModel.swift
//  Shopify
//
//  Created by aya on 08/06/2024.
//

import Foundation
class ShoppingCartViewModel {
    
    func fetchDraftOrders(completion: @escaping (DraftOrder?, Error?) -> Void) {
        let additionDraftOrder = "1184699220216.json"

        NetworkManager.fetchDataFromApi(endpoint: .draftOrder, rootOfJson: .draftOrderRoot,addition: additionDraftOrder) { (data, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }
            
            do {
                let draftOrders = try JSONDecoder().decode(DraftOrder.self, from: data)
                print("deaftOrder: \(draftOrders)")
                completion(draftOrders, nil)
            } catch let decodingError {
                print("Decoding error: \(decodingError)")
                completion(nil, decodingError)
            }
        }
    }
    
}


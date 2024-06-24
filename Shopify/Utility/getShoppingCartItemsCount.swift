//
//  getShoppingCartItemsCount.swift
//  Shopify
//
//  Created by mayar on 24/06/2024.
//

import Foundation

class GetShoppingCartItemsCount{

static func getShoppingCartItemsCount(completion: @escaping (Int?, Error?) -> Void) {
    
    let additionDraftOrder = "\(Authorize.cardDraftOrderId()!).json"
    NetworkManager.fetchDataFromApi(endpoint: .specficDraftOeder, rootOfJson: .specificDraftOrder, addition: additionDraftOrder) { (data, error) in
        
        if let error = error {
            completion(nil,error)
            return
        }
        
        guard let data = data else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
            return
        }
        
        do {
            print("Received data: \(String(data: data, encoding: .utf8) ?? "No data")")
            let draftOrders = try JSONDecoder().decode(DraftOrder.self, from: data)
            let cartItemsCount = (draftOrders.line_items?.count ?? 0)
            completion(cartItemsCount,nil)
        } catch let decodingError {
            completion(nil,decodingError)
        }
    }
    
}
}

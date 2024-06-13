//
//  OrderViewModel.swift
//  Shopify
//
//  Created by Rawan Elsayed on 12/06/2024.
//

import Foundation

class OrderViewModel{
    
    func createOrder(completion: @escaping (ConfirmOrder?, Error?) -> Void) {
        let lineItem = LineItems(variant_id: 45293436961016, quantity: 10)
        let shippingAddress = Addresses(first_name: "MRDRJohn",
                                      last_name: "MRDRDoe",
                                      address1: "123 Elm St2",
                                      city: "Anytown",
                                      province: "ON",
                                      country: "CA",
                                      zip: "K1A 0B1")
        
        let confirmOrder = ConfirmOrder(email: "customer222@example.com",
                                        fulfillment_status: "fulfilled",
                                        line_items: [lineItem],
                                        financial_status: "paid",
                                        shipping_address: shippingAddress)
        
        do {
            let data = try JSONEncoder().encode(confirmOrder)
            NetworkManager.postDataToApi(endpoint: .order, rootOfJson: .order, body: data) { responseData, networkError in
                guard let data = responseData, networkError == nil else {
                    completion(nil, networkError)
                    return
                }
                print("before docoding")
                do {
                    let decodedOrder = try JSONDecoder().decode(ConfirmOrder.self, from: data)
                    completion(decodedOrder, nil)
                } catch let decodeError {
                    completion(nil, decodeError)
                }
            }
        } catch let encodeError {
            completion(nil, encodeError)
        }
    }
    
}

//
//  OrderViewModel.swift
//  Shopify
//
//  Created by Rawan Elsayed on 12/06/2024.
//

import Foundation

class OrderViewModel {
    
    var orders: [ConfirmOrder] = []
    
//    func createOrder(completion: @escaping (ConfirmOrder?, Error?) -> Void) {
//        let lineItem = LineItem(variant_id: 45293436961016, quantity: 10)
//        let shippingAddress = Address(first_name: "testOder",
//                                        last_name: "testing",
//                                        address1: "123 Elm St2",
//                                        city: "Anytown",
//                                        province: "ON",
//                                        country: "CA",
//                                        zip: "K1A 0B1")
//
//        let confirmOrder = ConfirmOrder(email: "customer222@example.com",
//                                        fulfillment_status: "fulfilled",
//                                        line_items: [lineItem],
//                                        financial_status: "paid",
//                                        shipping_address: shippingAddress)
//
//        let orderPayload = ["order": confirmOrder]
//
//        do {
//            let data = try JSONEncoder().encode(orderPayload)
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Request Body JSON: \(jsonString)") // Print JSON string for debugging
//            }
//            NetworkManager.postDataToApi(endpoint: .order, rootOfJson: .order, body: data) { responseData, networkError in
//                guard let data = responseData, networkError == nil else {
//                    completion(nil, networkError)
//                    return
//                }
//                print("Response Data: \(String(data: data, encoding: .utf8) ?? "No response data")") // Print raw response data for debugging
//                
//                do {
//                    let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                    if let orderData = responseDict?["order"] {
//                        let orderDataJson = try JSONSerialization.data(withJSONObject: orderData)
//                        let decodedOrder = try JSONDecoder().decode(ConfirmOrder.self, from: orderDataJson)
//                        completion(decodedOrder, nil)
//                    } else {
//                        completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Order data missing in response"]))
//                    }
//                } catch let decodeError {
//                    completion(nil, decodeError)
//                }
//            }
//        } catch let encodeError {
//            completion(nil, encodeError)
//        }
//    }
    
    func fetchOrders(completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.fetchDataFromApi(endpoint: .order, rootOfJson: .orders, addition: "?status=any") { responseData, networkError in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            guard let data = responseData else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            Decoding.decodeData(data: data, objectType: [ConfirmOrder].self) { decodedOrders, decodeError in
                if let decodedOrders = decodedOrders {
                    self.orders = decodedOrders
                    completion(.success(()))
                } else if let decodeError = decodeError {
                    completion(.failure(decodeError))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode orders"])))
                }
            }
        }
    }

}


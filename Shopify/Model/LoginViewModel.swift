//
//  LoginViewModel.swift
//  Shopify
//
//  Created by mayar on 09/06/2024.
//

import Foundation

class LoginViewModel {

    func isACustomer(email: String, password: String, completion: @escaping (Bool) -> Void) {
               
        NetworkManager.fetchDataFromApi(endpoint: .customers, rootOfJson: .customers) { data, error in
            guard let data = data, error == nil else {
                print("Error fetching customer data:", error?.localizedDescription ?? "Unknown error")
                completion(false) 
                return
            }
            print("Data received from API:", data)

            Decoding.decodeData(data: data, objectType: [Customer].self) { [weak self] (allCustomers, decodeError) in
                guard let self = self else {
                    completion(false)
                    return
                }
                print("all customers: \(allCustomers)")
                
                if let allCustomers = allCustomers {
                    let isCustomer = allCustomers.contains { $0.email == email && $0.tags == password }
                    if isCustomer {
                        if let customerID = allCustomers.first(where: { $0.email == email && $0.tags == password })?.id {
                            print("customerID\(customerID)")
                            Authorize.saveCustomerIDToUserDefaults(customerID: customerID)
                            self.getDraftOrdersIdsByCustomerId(customerID: customerID, email:email)
                        }
                    }
                    completion(isCustomer)
                } else {
                    print("Error decoding customer data:", decodeError?.localizedDescription ?? "Unknown error")
                    completion(false)
                }
            }
        }
    }
    
    
    
    func getDraftOrdersIdsByCustomerId(customerID: Int, email: String) {
        var allCustomerDraftOrders: [DraftOrder] = []

        NetworkManager.fetchDataFromApi(endpoint: .draftOrder, rootOfJson: .draftOrderRoot) { data, error in
            guard let data = data, error == nil else {
                print("Error in data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            Decoding.decodeData(data: data, objectType: [DraftOrder].self) { allDraftOrders, decodeError in
                guard let allDraftOrders = allDraftOrders, decodeError == nil else {
                    print("Decoding error: \(decodeError?.localizedDescription ?? "Unknown error")")
                    return
                }
                for draftOrder in allDraftOrders {
                    if draftOrder.email == email {
                        allCustomerDraftOrders.append(draftOrder)
                    }
                }

                if let firstDraftOrderId = allCustomerDraftOrders[0].id {
                    Authorize.favDraftOrder(draftOrderIDOne: firstDraftOrderId)
                } else {
                    print("First draft order ID is nil")
                }

                if let secondDraftOrderId = allCustomerDraftOrders[1].id {
                    Authorize.cardDraftOrderId(draftOrderIDTwo: secondDraftOrderId)
                } else {
                    print("Second draft order ID is nil")
                }
            }
            
            print("draftorders fav : \(Authorize.favDraftOrder())")
            print("draftorders card : \(Authorize.cardDraftOrderId())")

        }
    }

}

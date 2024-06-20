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
                            self.getDraftOrdersIdsByCustomerEmail(email:email)
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
    
    func getDraftOrdersIdsByCustomerEmail( email: String) {
        var allCustomerDraftOrders: [DraftOrder] = []

        NetworkManager.fetchDataFromApi(endpoint: .draftOrder, rootOfJson: .allDraftOrderRoot) { data, error in
            guard let data = data, error == nil else {
                print("Error in data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            Decoding.decodeData(data: data, objectType: [DraftOrder].self) { allDraftOrders, decodeError in
                guard let allDraftOrders = allDraftOrders, decodeError == nil else {
                    print("Decoding error before deaft order: \(decodeError?.localizedDescription ?? "Unknown error")")
                    return
                }
                print("allDraftOrders.count \(allDraftOrders.count)")
                for draftOrder in allDraftOrders {
                    if draftOrder.email == email {
                        print("Email is found")
                        allCustomerDraftOrders.append(draftOrder)
                        print("Email \(allCustomerDraftOrders.count)")
                    }
                }

                if let firstDraftOrderId = allCustomerDraftOrders[0].id{
                    print("Email after login fav draft is \(firstDraftOrderId)")
                    Authorize.favDraftOrder(draftOrderIDOne: firstDraftOrderId)
                } else {
                    print("Email First draft order ID is nil")
                }

                if let secondDraftOrderId = allCustomerDraftOrders[1].id {
                    print("Email after login secondDraftOrderId \(secondDraftOrderId)")

                    Authorize.cardDraftOrderId(draftOrderIDTwo: secondDraftOrderId)
                } else {
                    print("Email Second draft order ID is nil")
                }
            }
        }
    }

}

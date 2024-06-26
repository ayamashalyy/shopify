//
//  LoginViewModel.swift
//  Shopify
//
//  Created by mayar on 09/06/2024.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

class LoginViewModel {
    
    
    func isValidedEmail (email: String, password: String, completion: @escaping (Bool) -> Void){
        AuthenticationManger.signInUser(email: email, password: password) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    print( "Sign-in successful. Email is verified.")
                    self.isACustomer(email: email, password: password){ finish in
                        completion(finish)
                        
                    }
                } else {
                    print( "Sign-in nottttt successful. Email is not verified.")
                    completion(false)
                }
            }
        }
    }
    
    func isACustomer(email: String, password: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.fetchDataFromApi(endpoint: .customers, rootOfJson: .customers) { data, error in
            guard let data = data, error == nil else {
                print("Error fetching all customers data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            print("Data received from API:", data)
            
            Decoding.decodeData(data: data, objectType: [Customer].self) { [weak self] (allCustomers, decodeError) in
                print("1")
                guard let self = self else {
                    print("2")
                    return
                }
                
                if let allCustomers = allCustomers {
                    print("3")
                    let isCustomer = allCustomers.contains { $0.email == email && $0.tags == password }
                    print("is customer\(isCustomer)............................4")
                    if isCustomer {
                        print("5")
                        if let customerID = allCustomers.first(where: { $0.email == email && $0.tags == password })?.id {
                            print("customerID\(customerID)")
                            Authorize.saveCustomerIDToUserDefaults(customerID: customerID)
                            
                            Authorize.saveCustomerEmail(Customeremail: email)
                            
                            let name = allCustomers.first(where: { $0.email == email && $0.tags == password })?.firstName
                            print("full name \(name!)")
                            
                            Authorize.saveCustomerFullName(customerFullName: name!)
                            self.getDraftOrdersIdsByCustomerEmail(email:email)
                            completion(true)
                        }
                        else
                        {
                            print("There are problem in customer id")
                        }
                    }
                } else {
                    print("Error decoding customer data:", decodeError?.localizedDescription ?? "Unknown error")
                    completion(false)
                }
            }
        }
    }
    
    
    
    func isACustomerComeFromGoogle(email: String, password: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.fetchDataFromApi(endpoint: .customers, rootOfJson: .customers) { data, error in
            guard let data = data, error == nil else {
                print("Error fetching all customers data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            print("Data received from API:", data)
            
            Decoding.decodeData(data: data, objectType: [Customer].self) { [weak self] (allCustomers, decodeError) in
                print("1")
                guard let self = self else {
                    print("2")
                    return
                }
                
                if let allCustomers = allCustomers {
                    print("3")
                    let isCustomer = allCustomers.contains { $0.email == email }
                    print("is customer\(isCustomer)............................4")
                    if isCustomer {
                        print("5")
                        if let customerID = allCustomers.first(where: { $0.email == email })?.id {
                            print("customerID\(customerID)")
                            Authorize.saveCustomerIDToUserDefaults(customerID: customerID)
                            
                            Authorize.saveCustomerEmail(Customeremail: email)
                            
                            let name = allCustomers.first(where: { $0.email == email })?.firstName
                            print("full name \(name!)")
                            
                            Authorize.saveCustomerFullName(customerFullName: name!)
                            self.getDraftOrdersIdsByCustomerEmail(email:email)
                            completion(true)
                        }
                        else
                        {
                            print("There are problem in customer id")
                        }
                    }
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
                    print("after login secondDraftOrderId \(secondDraftOrderId)")
                    
                    print("Email after login secondDraftOrderId \(secondDraftOrderId)")
                    
                    Authorize.cardDraftOrderId(draftOrderIDTwo: secondDraftOrderId)
                } else {
                    print("Email Second draft order ID is nil")
                }
            }
        }
    }
    
}

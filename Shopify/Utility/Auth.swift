//
//  Auth.swift
//  Shopify
//
//  Created by mayar on 09/06/2024.
//

import Foundation

class Authorize{

    static let customerIDKey = "CustomerID"
        
        static func saveCustomerIDToUserDefaults(customerID: Int) {
            UserDefaults.standard.set(customerID, forKey: customerIDKey)
        }
        
        static func getCustomerIDFromUserDefaults() -> Int? {
            // if make get and their is no id will get 0
            return UserDefaults.standard.integer(forKey: customerIDKey)
        }
        
        static func clearCustomerIDFromUserDefaults() {
            print("clear user key")
            UserDefaults.standard.removeObject(forKey: customerIDKey)
        }
    }


/*

 // To access the customer ID from anywhere in the application
 if let customerID = Authorize.getCustomerIDFromUserDefaults() {
     print("Customer ID:", customerID)
 }
 
 // Log out action
 func logout() {
     // Clear the saved customer ID
     Authorize.clearCustomerIDFromUserDefaults()
 // navigtion to login
 }

 */

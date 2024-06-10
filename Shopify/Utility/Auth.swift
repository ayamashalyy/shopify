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
            return UserDefaults.standard.integer(forKey: customerIDKey)
        }
        
        static func clearCustomerIDFromUserDefaults() {
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
     // Perform any additional logout tasks
 }

 */

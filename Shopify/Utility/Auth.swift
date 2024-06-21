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
    
    
    
    static let CustomerEmailKey = "CustomerEmail"
    static func saveCustomerEmail(Customeremail: String) {
        UserDefaults.standard.set(Customeremail, forKey: CustomerEmailKey)
    }
    static func getCustomeremail() -> String? {
        return UserDefaults.standard.string(forKey: CustomerEmailKey)
    }
    static func clearCustomerEmail() {
        UserDefaults.standard.removeObject(forKey: CustomerEmailKey)
    }
    
    static let CustomerFullName = "CustomerName"
    static func saveCustomerFullName(customerFullName: String) {
        UserDefaults.standard.set(customerFullName, forKey: CustomerFullName)
    }
    static func getCustomerFullName() -> String? {
        return UserDefaults.standard.string(forKey: CustomerFullName)
    }
    static func clearCustomerFullName() {
        UserDefaults.standard.removeObject(forKey: CustomerFullName)
    }
    
    
    static let draftOrderIDOneSting = "draftOrderIDOne"
    static func favDraftOrder(draftOrderIDOne: Int) {
        print("favDraftOrder seeeet   \(draftOrderIDOne) ")
        
        UserDefaults.standard.set(draftOrderIDOne, forKey: draftOrderIDOneSting )
    }
    static  func favDraftOrder() -> Int? {
        return UserDefaults.standard.integer(forKey: draftOrderIDOneSting)
    }
    static  func clearFavDraftOrder() {
        UserDefaults.standard.removeObject(forKey: draftOrderIDOneSting)
    }
    
    
    
    static let draftOrderIDTwoSting = "draftOrderIDTwo"
    static func cardDraftOrderId(draftOrderIDTwo: Int) {
        print("cardDraftOrderId seeeet  \(draftOrderIDTwo) ")
        UserDefaults.standard.set(draftOrderIDTwo, forKey: draftOrderIDTwoSting )
    }
    
    static  func cardDraftOrderId() -> Int? {
        return UserDefaults.standard.integer(forKey: draftOrderIDTwoSting)
    }
    static  func clearCardDraftOrderId() {
        UserDefaults.standard.removeObject(forKey: draftOrderIDTwoSting)
    }
    
    // the function that call it also should go to navigation to login
    static func logout () {
        Authorize.clearCardDraftOrderId()
        Authorize.clearCustomerIDFromUserDefaults()
        Authorize.clearFavDraftOrder()
        Authorize.clearCustomerEmail()
        Authorize.clearCustomerFullName()
    }
    
    static func isRegistedCustomer () -> Bool {
        let customerID = Authorize.getCustomerIDFromUserDefaults()
        let customerEmail = Authorize.getCustomeremail()
        if customerID != 0 || customerEmail != nil {
            print("he isRegistedCustomer ")
            return true
        }
        else{
            print("he is guest ")
            
            return false
        }
    }
}

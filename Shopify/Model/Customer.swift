//
//  Customer.swift
//  Shopify
//
//  Created by mayar on 09/06/2024.
//

import Foundation

class CustomerResponse: Codable {
    let customer: Customer
    
    init(customer: Customer) {
        self.customer = customer
    }
}

class Customer: Codable {
    let id: Int?
    let email: String
    let firstName: String
    let lastName: String
    let verifiedEmail: Bool
    let tags: String
    let currency: String?
    let phone: String?
    let orders_count: Int?
     
    let last_order_id: Int?
    let last_order_name: String?
      
    let addresses: [Address]?
    let password: String?
    let passwordConfirmation: String?
    let sendEmailWelcome: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, email , last_order_name, last_order_id, orders_count
        case firstName = "first_name"
        case lastName = "last_name"
        case verifiedEmail = "verified_email"
        case tags, currency, phone, addresses
        case password, passwordConfirmation = "password_confirmation"
        case sendEmailWelcome = "send_email_welcome"
    }
    
    init(id: Int? = nil, last_order_id: Int? = nil, last_order_name: String? = nil,orders_count:Int? = nil,  email: String, firstName: String, lastName: String, verifiedEmail: Bool, tags: String, password: String? = nil, passwordConfirmation: String? = nil, sendEmailWelcome: Bool = true, currency: String? = nil, phone: String? = nil, addresses: [Address]? = nil) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.verifiedEmail = verifiedEmail
        self.tags = tags
        self.password = password
        self.passwordConfirmation = passwordConfirmation
        self.sendEmailWelcome = sendEmailWelcome
        self.currency = currency
        self.phone = phone
        self.addresses = addresses
        self.last_order_id = last_order_id
        self.last_order_name = last_order_name
        self.orders_count = orders_count
    }
}
class CustomerRequest: Codable {
    let customer: Customer
    
    init(customer: Customer) {
        self.customer = customer
    }
}

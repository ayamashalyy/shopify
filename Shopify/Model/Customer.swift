//
//  Customer.swift
//  Shopify
//
//  Created by mayar on 09/06/2024.
//

import Foundation

class Customer: Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let verifiedEmail: Bool
    let tags: String
    var currency: String?
    var addresses: [Address]?
    var defaultAddress: Address?
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case verifiedEmail = "verified_email"
        case tags, currency, addresses
        case defaultAddress = "default_address"
    }
    
    init(id: String, email: String, firstName: String, lastName: String, verifiedEmail: Bool, tags: String, currency: String? = nil, addresses: [Address]? = nil, defaultAddress: Address? = nil) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.verifiedEmail = verifiedEmail
        self.tags = tags
        self.currency = currency
        self.addresses = addresses
        self.defaultAddress = defaultAddress
    }
}




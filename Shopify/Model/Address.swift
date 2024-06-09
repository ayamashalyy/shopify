//
//  Address.swift
//  Shopify
//
//  Created by aya on 08/06/2024.
//

import Foundation

struct Address: Codable {
    let id: Int
    let customerId: Int?
    let firstName: String?
    let lastName: String?
    let company: String?
    let address1: String
    let address2: String?
    let city: String
    let province: String?
    let country: String
    let zip: String?
    let phone: String?
    let name: String?
    let provinceCode: String?
    let countryCode: String?
    let countryName: String?
    let defaultAddress: Bool?

    init(address1: String, phone: String, city: String, country: String, zip: String) {
        self.address1 = address1
        self.phone = phone
        self.city = city
        self.country = country
        self.zip = zip
        self.id = 0
        self.customerId = nil
        self.firstName = nil
        self.lastName = nil
        self.company = nil
        self.address2 = nil
        self.province = nil
        self.name = nil
        self.provinceCode = nil
        self.countryCode = nil
        self.countryName = nil
        self.defaultAddress = nil
    }
}

struct AddressListResponse: Codable
{
    let addresses: [Address]
}
struct AddressResponse: Codable {
    let customer_address: Address
}

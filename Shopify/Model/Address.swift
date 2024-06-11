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
    let isDefault: Bool?
    
    init(id: Int, address1: String, phone: String, city: String, country: String, zip: String, isDefault: Bool) {
        self.id = id
        self.address1 = address1
        self.phone = phone
        self.city = city
        self.country = country
        self.zip = zip
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
        self.isDefault = isDefault
    }
    enum CodingKeys: String, CodingKey {
            case id
            case customerId = "customer_id"
            case firstName = "first_name"
            case lastName = "last_name"
            case company
            case address1
            case address2
            case city
            case province
            case country
            case zip
            case phone
            case name
            case provinceCode = "province_code"
            case countryCode = "country_code"
            case countryName = "country_name"
            case isDefault = "default"
        }
}

struct AddressListResponse: Codable
{
    let addresses: [Address]
}
struct AddressResponse: Codable {
    let customer_address: Address
}

//
//  Order.swift
//  Shopify
//
//  Created by Rawan Elsayed on 12/06/2024.
//

import Foundation

struct ConfirmOrder: Codable {
    let email: String
    let fulfillment_status: String
    let line_items: [LineItems]
    let financial_status: String
    let shipping_address: Addresses
}

struct LineItems: Codable {
    let variant_id: Int
    let quantity: Int
}

struct Addresses: Codable {
    let first_name: String
    let last_name: String
    let address1: String
    let city: String
    let province: String
    let country: String
    let zip: String
}


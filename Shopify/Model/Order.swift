//
//  Order.swift
//  Shopify
//
//  Created by Rawan Elsayed on 12/06/2024.
//

import Foundation

struct ConfirmOrder: Codable {
    let id : Int?
    let email: String
    let fulfillment_status: String?
    let line_items: [LineItem]?
    let financial_status: String?
    let shipping_address: AddressDraftOrder?
    let currency: String?
    let current_subtotal_price: String?
    let current_total_discounts: String?
    let number: Int?
    let order_number: Int?
    let phone: String?
    let created_at: String?
    let customer: Customer?
}

struct OrdersResponse: Codable {
    let orders: [ConfirmOrder]
}


//
//  DiscountCode.swift
//  Shopify
//
//  Created by Rawan Elsayed on 15/06/2024.
//

import Foundation

struct DiscountCode: Codable {
    let id: Int
    let price_rule_id: Int
    let code: String
    let usage_count: Int
    let created_at: String
    let updated_at: String
}

struct DiscountCodeResponse: Codable {
    let discountCodes: [DiscountCode]
}

struct PriceRule: Codable {
    let id: Int
    let value_type: String
    let value: String
    let customer_selection: String
    let target_type: String
    let target_selection: String
    let allocation_method: String
    let once_per_customer: Bool
    let usage_limit: Int?
    let starts_at: String
    let ends_at: String?
    let title: String?
    var discountValue: Int? {
        return PriceRuleValue.fromString(value)?.rawValue
    }
}

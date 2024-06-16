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

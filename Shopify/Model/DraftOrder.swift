//
//  DraftOrder.swift
//  Shopify
//
//  Created by aya on 08/06/2024.
//

import Foundation
struct LineItem {
    let id, variantID, productID: Int
    let title, variantTitle, sku, vendor: String
    let quantity: Int
    let requiresShipping, taxable, giftCard: Bool
    let fulfillmentService: String
    let grams: Int
    let taxLines: [TaxLine]
    let appliedDiscount: NSNull
    let name: String
    let properties: [Any?]
    let custom: Bool
    let price, adminGraphqlAPIID: String
}

struct TaxLine {
    let title, price: String
}

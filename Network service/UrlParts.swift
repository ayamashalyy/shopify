//
//  UrlParts.swift
//  Shopify
//
//  Created by mayar on 24/06/2024.
//

import Foundation


enum Endpoint: String {
    case smartCollections = "smart_collections.json"
    case specificProduct = "products/"
    case listOfBrandProducts = "products.json?vendor="
    case customers = "customers.json"
    case addressCastomer = "customers/"
    case order = "orders.json"
    case discount_code = "price_rules"
    case allProduct = "products.json"
    case draftOrder = "draft_orders.json"
    case specficDraftOeder = "draft_orders/"
    case listOfCategoriesProducts = "products.json?collection_id="
}

enum Root: String {
    case smartCollectionsRoot = "smart_collections"
    case product = "product"
    case products = "products"
    case customers = "customers"
    case customer = "customer"
    case address = "addresses"
    case allDraftOrderRoot = "draft_orders"
    case specificDraftOrder = "draft_order"
    case order = "order"
    case orders = "orders"
    case discountCodes = "discount_codes"
    case priceRules = "price_rules"
    case sendingInvoice = "draft_order_invoice"
}

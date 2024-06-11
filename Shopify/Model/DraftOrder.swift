//
//  DraftOrder.swift
//  Shopify
//
//  Created by aya on 08/06/2024.
//

import Foundation

struct DraftOrderResponse: Codable {
    let draft_orders: [DraftOrder]
    
}

struct DraftOrder: Codable {
    let id: Int?
    let note: String?
    let email: String
    let taxes_included: Bool?
    let currency: String?
    let invoice_sent_at: String?
    let created_at: String?
    let updated_at: String?
    let tax_exempt: Bool?
    let completed_at: String?
    let name: String?
    let status: String?
    let line_items: [LineItem]?
    let shipping_address: AddressDraftOrder?
    let billing_address: AddressDraftOrder?
    let invoice_url: String?
    let applied_discount: String?
    let order_id: String?
    let shipping_line: String?
    let tax_lines: [TaxLine]?
    let tags: String?
    let note_attributes: [String?]
    let total_price: String?
    let subtotal_price: String?
    let total_tax: String?
    let payment_terms: String?
    let admin_graphql_api_id: String?
    let customer: CustomerDraftOrder?
    
    enum CodingKeys: String, CodingKey {
        case id, note, email, taxes_included, currency, invoice_sent_at, created_at, updated_at, tax_exempt, completed_at, name, status, line_items, shipping_address, billing_address, invoice_url, applied_discount, order_id, shipping_line, tax_lines, tags, note_attributes, total_price, subtotal_price, total_tax, payment_terms, admin_graphql_api_id, customer
    }
}

struct LineItem: Codable  {
    let id, variant_id, product_id: Int?
    let title, variant_title, sku, vendor: String?
    let quantity: Int?
    let requires_shipping, taxable, gift_card: Bool?
    let fulfillment_service: String?
    let grams: Int?
    let tax_lines: [TaxLine]?
    let applied_discount: String?
    let name: String?
    let properties: [String?]
    let custom: Bool?
    let price, admin_graphql_api_id: String?
}

struct AddressDraftOrder: Codable {
    let first_name, address1: String?
    let phone: String?
    let city: String?
    let zip, province: String?
    let country, last_name: String?
    let address2, company: String?
    let latitude, longitude: Double?
    let name, country_code: String?
    let province_code: String?
    
}



struct CustomerDraftOrder: Codable  {
    let id: Int?
    let email: String?
    let created_at, updated_at: String?
    let first_name, last_name: String?
    let orders_count: Int?
    let state, total_spent: String?
    let last_order_id, note: String?
    let verified_email: Bool?
    let multipass_identifier: String?
    let tax_exempt: Bool?
    let tags: String?
    let last_order_name: String?
    let currency, phone: String?
    let tax_exemptions: [String?]
    let email_marketing_consent, smsMarketingConsent: MarketingConsent?
    let admin_graphql_api_id: String?
    let default_address: AddressDraftOrder?
}


struct MarketingConsent: Codable  {
    let state, opt_in_level: String?
    let consent_updated_at: String?
    let consent_collected_from: String?
}

struct TaxLine: Codable {
    let rate: Double?
    let title: String?
    let price: String?
}

//
//  CategoryProducts.swift
//  Shopify
//
//  Created by Rawan Elsayed on 10/06/2024.
//

import Foundation

struct CategoryProducts: Codable {
    let id: Int
    let title: String
    let body_html: String
    let vendor: String
    let product_type: String
//    let created_at: String
//    let handle: String
//    let updated_at: String
//    let published_at: String
//    //let templateSuffix: String?
//    //let publishedScope: String
//    let tags: String
//    let status: String
//    //let adminGraphqlApiID: String
//    //let variant_ids: [CategoryProductVariant]
//    let options: [Option]
    let images: [CategoryProductImage]
//    let image: CategoryProductImage
}

//struct Option: Codable {
//    let id, product_id: Int
//    let name: String
//    let position: Int
//    let values: [String]
//}

struct CategoryProductImage: Codable {
    let id: Int
    let alt: String?
    let position, product_id: Int
    //let createdAt, updatedAt, adminGraphqlApiID: String
    let width, height: Int
    let src: String
}

//struct CategoryProductVariant: Codable {
//    let id, product_id: Int
//    let title: String
//    let price, sku: String
//    let position: Int
//    //let inventoryPolicy: String
//    //let fulfillmentService, inventoryManagement: String
//    let option1, option2: String
//    //let createdAt, updatedAt: String
//    let taxable: Bool
//    let grams: Int
//    let weight: Double
//    //let weightUnit: String
//    //let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int
//    //let requiresShipping: Bool
//    //let adminGraphqlApiID: String
//
//}





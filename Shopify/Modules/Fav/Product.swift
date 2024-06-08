//
//  Product.swift
//  Shopify
//
//  Created by mayar on 07/06/2024.
//

import Foundation

// MARK: - Product
class Product: Codable {
    let id: Int
    let title: String
    // descption
    let bodyHTML: String
    let variants: [Variant]
    // 3 url
    let images: [ProductImage]
    
// By using CodingKeys, we ensure that the JSON decoding process works correctly even when the naming conventions differ between JSON keys and Swift property names.

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case bodyHTML = "body_html"
        case variants
        case images
    }
}

// MARK: - Variant
class Variant: Codable {
    let price: String
    //size
    let option1: String
    //color
    let option2: String?
    let option3: String?
}

// MARK: - ProductImage
class ProductImage: Codable {
    //url
    let src: String
}


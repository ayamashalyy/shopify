//
//  Product.swift
//  Shopify
//
//  Created by mayar on 07/06/2024.
//

import Foundation
// Product.swift
// Shopify
// Created by mayar on 07/06/2024.

import Foundation

// MARK: - Product
class Product: Codable {
    let id: Int
    let name: String
    let description: String
    let variants: [Variant]
    let images: [ProductImage]

    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case description = "body_html"
        case variants
        case images
    }
}

// MARK: - Variant
class Variant: Codable {
    let id: Int
    let price: String
    let size: String
    let color: String?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case price
        case size = "option1"
        case color = "option2"
    }
}

// MARK: - ProductImage
class ProductImage: Codable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url = "src"
    }
}


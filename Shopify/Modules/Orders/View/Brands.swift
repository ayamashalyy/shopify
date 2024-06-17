//
//  Brands.swift
//  Shopify
//
//  Created by Rawan Elsayed on 07/06/2024.
//

import Foundation

struct Brand:Codable {
    let id: Int
    let handle: String
    let title: String
    let image: Image
}
struct Image: Codable{
    let src: String
}

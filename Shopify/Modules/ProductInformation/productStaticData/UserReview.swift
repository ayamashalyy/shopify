//
//  UserReview.swift
//  Shopify
//
//  Created by mayar on 08/06/2024.
//

import Foundation

class UserReview {

    static func getReviews() -> [(String, String, String, Double)] {
            return [
                ("Aya Ibrahuim", "This is a great product", "a", 4.5),
                ("Rewan Mohamed", "Worth the price.", "r", 4.0),
                ("Somai Amar", "Good", "s", 3.5),
                ("Mayar Saleh", "Average quality.", "m", 3.0)
            ]
        }
}

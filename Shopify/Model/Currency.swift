//
//  Currency.swift
//  Shopify
//
//  Created by Rawan Elsayed on 11/06/2024.
//

import Foundation

struct Currency: Decodable , Encodable {
    let result: String
    let documentation: String
    //let termsOf_use: String
    let time_last_update_unix: Int
    let time_last_update_utc: String
    let time_next_update_unix: Int
    let time_next_update_utc: String
    let base_code: String
    let conversion_rates: [String: Double]
}

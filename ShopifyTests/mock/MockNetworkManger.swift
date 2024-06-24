//
//  MockNetworkManger.swift
//  ShopifyTests
//
//  Created by mayar on 24/06/2024.
//

import Foundation
@testable import Shopify

class MockNetworkManagerMethods {
    
    var networkConnection: Bool
    init(networkConnection: Bool) {
        self.networkConnection = networkConnection
    }
    
    
    let fakeProductJson: [String: Any] = [
        "product": [
            "id": 8575848153336,
            "title": "ADIDAS | CLASSIC BACKPACK",
            "body_html": "This women's backpack has a glam look, thanks to a faux-leather build with an allover fur print. The front zip pocket keeps small things within reach, while an interior divider reins in potential chaos.",
            "variants": [
                [
                    "id": 45293446398200,
                    "product_id": 8575848153336,
                    "title": "5xl / red",
                    "price": "999.00",
                ]
            ],
            
            "images": [
                [
                    "id": 41189218681080,
                    "alt": nil,
                    "position": 1,
                    "product_id": 8575848153336,
                         "src": "https://cdn.shopify.com/s/files/1/0703/6328/3704/files/85cc58608bf138a50036bcfe86a3a362.jpg?v=1717674850",
                    "variant_ids": []
                ]
            ]
        ]
    ]
}

extension MockNetworkManagerMethods {
    
    enum ErrorResponse: Error {
        case errorResponse
    }
    
    func fetchDataFromApi(endpoint: Endpoint, rootOfJson: Root, addition: String? = "", completion: @escaping (Data?, Error?) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeProductJson, options: [])
            if networkConnection {
                completion(nil, ErrorResponse.errorResponse)
            } else {
                completion(data, nil)
            }
        } catch {
            completion(nil, ErrorResponse.errorResponse)
        }
    }
}

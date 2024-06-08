//
//  Decoding.swift
//  Shopify
//
//  Created by mayar on 07/06/2024.
//

import Foundation

class Decoding {
   
    static func decodeData<T: Codable>(data: Data, objectType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            completion(decodedObject, nil)
        } catch {
            completion(nil, error)
        }
    }
    
}

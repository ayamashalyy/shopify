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
            print("data before decode \(data)")
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            print("data after decode decodedObject \(decodedObject)")

            completion(decodedObject, nil)
        } catch {
            print("failed to decode ")
            print("failed to decode error \(error)")

            completion(nil, error)
        }
    }
    
    static func encodeData<T: Codable>(object: T, completion: @escaping (Data?, Error?) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(object)
            completion(jsonData, nil)
        } catch {
            completion(nil, error)
        }
    }

}

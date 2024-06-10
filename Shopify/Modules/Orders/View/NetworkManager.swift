//
//  NetworkCall.swift
//  Shopify
//
//  Created by Rawan Elsayed on 07/06/2024.
//

import Foundation
import Alamofire 



enum Endpoint: String {
    case smartCollections = "smart_collections.json"
    case specificProduct = "products/"
    case listOfBrandProducts = "products.json?collection_id="
    case productsByCategory = "collections/"
    case allProduct = "products.json"
    //    8575848153336.json
}

enum Root: String {
    case smartCollectionsRoot = "smart_collections"
    case product = "product"
    case products = "products"
    
}

// remove it every time before push

class NetworkManager {
    
    static func fetchDataFromApi(endpoint: Endpoint, rootOfJson: Root, addition: String? = "", completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "https://\(API_KEY):\(TOKEN)\(baseUrl)\(endpoint.rawValue)\(addition ?? "")"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else {
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]))
                    return
                }
                
                var jsonData: Data?
                if let jsonObject = json[rootOfJson.rawValue] as? [String: Any] {
                    // Handle single object
                    jsonData = try? JSONSerialization.data(withJSONObject: jsonObject)
                } else if let jsonArray = json[rootOfJson.rawValue] as? [[String: Any]] {
                    // Handle array of objects
                    jsonData = try? JSONSerialization.data(withJSONObject: jsonArray)
                } else {
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON root format"]))
                    return
                }
                
                if let jsonData = jsonData {
                    completion(jsonData, nil)
                } else {
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Serialization error"]))
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

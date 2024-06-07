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
    
}

enum Root: String {
    case smartCollectionsRoot = "smart_collections"
    
}

class NetworkManager {
    
    static func fetchDataFromApi(endpoint: Endpoint, rootOfJson: Root, completion: @escaping (Data?, Error?) -> Void) {
            guard let url = URL(string: "https://" + API_KEY + ":" + TOKEN + baseUrl + endpoint.rawValue) else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return
            }

            Alamofire.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? [String: Any], let jsonObject = json[rootOfJson.rawValue] as? [[String: Any]] else {
                        completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]))
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
                        completion(jsonData, nil)
                    } catch {
                        completion(nil, error)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
}

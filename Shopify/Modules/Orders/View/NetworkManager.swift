//
//  NetworkCall.swift
//  Shopify
//
//  Created by Rawan Elsayed on 07/06/2024.
//

import Foundation
import Alamofire 

enum Endpoint: String {
    case smartCollections = "smart_collections"
    
}

class NetworkManager {
    
    static func fetchDataFromApi<T: Codable>(endpoint: Endpoint, objectType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: "https://" + API_KEY + ":" + TOKEN + baseUrl + endpoint.rawValue + ".json") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any], let smartCollections = json["smart_collections"] as? [[String: Any]] else {
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]))
                    return
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: smartCollections)
                    let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(decodedObject, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

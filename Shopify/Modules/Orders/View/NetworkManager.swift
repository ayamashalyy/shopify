//
//  NetworkCall.swift
//  Shopify
//
//  Created by Rawan Elsayed on 07/06/2024.
//

import Foundation
import Alamofire 


// remove it every time before push

class NetworkManager {
    
    static func fetchDataFromApi(endpoint: Endpoint, rootOfJson: Root, addition: String? = "", completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "https://\(API_KEY):\(TOKEN)\(baseUrl)\(endpoint.rawValue)\(addition ?? "")"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        print("url in fetching    \(urlString)")
        
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
                    //        print("is single ")
                } else if let jsonArray = json[rootOfJson.rawValue] as? [[String: Any]] {
                    // Handle array of objects
                    //        print("is arrary ")
                    jsonData = try? JSONSerialization.data(withJSONObject: jsonArray)
                    //             print("jsonData  \(jsonData)")
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
    
    static func postDataToApi(endpoint: Endpoint, rootOfJson: Root, body: Data, addition: String? = "", completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "https://\(API_KEY):\(TOKEN)\(baseUrl)\(endpoint.rawValue)\(addition ?? "")"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(TOKEN, forHTTPHeaderField: "X-Shopify-Access-Token")
        request.httpBody = body
        Alamofire.request(request)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    print("Success in post")
                    completion(data, nil)
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("Response Body: \(jsonString)")
                    }
                    print("Network request failed with error: \(error)")
                    completion(nil, error)
                }
            }
        
    }
    
    
    static func fetchExchangeRates(urlString: String ,completion: @escaping (Data?, Error?) -> Void) {
        Alamofire.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static func updateResource(endpoint: Endpoint, rootOfJson: Root, body: Data, addition: String? = "", completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "https://\(API_KEY):\(TOKEN)\(baseUrl)\(endpoint.rawValue)\(addition ?? "")"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(urlString)"]))
            return
        }
        print("in updateResource urlString\(urlString)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(TOKEN, forHTTPHeaderField: "X-Shopify-Access-Token")
        request.httpBody = body
        
        Alamofire.request(request)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    print("Success in PUT request")
                    completion(data, nil)
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("Response Body: \(jsonString)")
                    }
                    print("Network request failed with error: \(error.localizedDescription)")
                    completion(nil, error)
                    
                }
            }
    }
    
    static func deleteResource(endpoint: Endpoint, rootOfJson: Root, addition: String? = "", completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "https://\(API_KEY):\(TOKEN)\(baseUrl)\(endpoint.rawValue)\(addition ?? "")"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        print("in deleteResource urlString\(urlString)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(TOKEN, forHTTPHeaderField: "X-Shopify-Access-Token")
        
        Alamofire.request(request)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    print("Success in DELETE request")
                    completion(data, nil)
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("Response Body: \(jsonString)")
                    }
                    print("Network request failed with error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
    }
    
    
    
}

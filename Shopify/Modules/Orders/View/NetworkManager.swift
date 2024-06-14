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
    case customers = "customers.json"
    case addressCastomer = "customers/"
    case order = "orders.json"
    
    
    //case productsByCategory = "collections/"
    case allProduct = "products.json"
    
    case draftOrder = "draft_orders.json"
    case specficDraftOeder = "draft_orders/"


    
    //    8575848153336.json
}

enum Root: String {
    case smartCollectionsRoot = "smart_collections"
    case product = "product"
    case products = "products"
    case customers = "customers"
    case customer = "customer"
    case address = "addresses"
    
   case allDraftOrderRoot = "draft_orders"
    
    case specificDraftOrder = "draft_order"
    case order = "order"
    case orders = "orders"
}

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
                //    print("response is successed ")
                guard let json = value as? [String: Any] else {
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]))
                    return
                }
                //   print("JSON Response:", json)
                
         //       print("Raw JSON: \(json)")


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
    
    static func postDataToApi(endpoint: Endpoint, rootOfJson: Root, body: Data, completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "https://\(API_KEY):\(TOKEN)\(baseUrl)\(endpoint.rawValue)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(TOKEN, forHTTPHeaderField: "X-Shopify-Access-Token")
        request.httpBody = body
        
        //        // Print request details for debugging
        //        if let jsonString = String(data: body, encoding: .utf8) {
        //            print("Request Body JSON: \(jsonString)")
        //        }
        //        print("Request URL: \(urlString)")
        //        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        //
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
//        let urlString = "https://v6.exchangerate-api.com/v6/3f59a2c7ff27012aaa916946/latest/USD"
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

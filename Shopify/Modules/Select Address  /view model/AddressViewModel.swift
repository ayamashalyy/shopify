//
//  AddressViewModel.swift
//  Shopify
//
//  Created by aya on 08/06/2024.
//

import Foundation

//
//  AddressViewModel.swift
//  Shopify
//
//  Created by aya on 08/06/2024.
//

import Foundation
import Alamofire

class AddressViewModel {
    var addresses: [Address] = []
    
    
    func addAddress(_ address: Address, completion: @escaping (Swift.Result<Address, Error>) -> Void) {
      /*  let urlString =
        
        let addressDict: [String: Any] = [
            "address": [
                "address1": address.address1,
                "phone": address.phone,
                "city": address.city,
                "country": address.country,
                "zip": address.zip
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: addressDict, options: .prettyPrinted)
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            Alamofire.request(request)
                .validate()
                .responseData { response in
                    switch response.result {
                    case.success(let data):
                        print("Received data: \(data)")
                        if let contentType = response.response?.allHeaderFields["Content-Type"] as? String,
                           contentType.contains("application/json")
                        {
                            do {
                                let decoder = JSONDecoder()
                                let addressResponse = try decoder.decode(AddressResponse.self, from: data)
                                completion(.success(addressResponse.customer_address))
                                
                            } catch {
                                print("Error decoding JSON: \(error.localizedDescription)")
                                completion(.failure(error))
                            }
                        } else
                        {
                            print("Resceived non json resonse: \(String(data: data, encoding: .utf8) ?? "")")
                            let error = NSError(domain: "", code: 200,userInfo: [NSLocalizedDescriptionKey:"Unexpected non json resonse"])
                            completion(.failure(error))
                        }
                    case .failure(let error) :
                        print("Request failed: \(error)")
                        completion(.failure(error))
                    }
                }
        }
        catch
        {
            print("Error serializing json: \(error)")
            completion(.failure(error))
        }*/
    }
    
    func getAllAddresses(completion: @escaping (Swift.Result<[Address], Error>) -> Void) {
       /* let urlString =
        
        var request = URLRequest(url: URL(string: urlString)!, cachePolicy:.useProtocolCachePolicy)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request)
            .validate()
            .responseData { response in
                switch response.result {
                case.success(let data):
                    print("Received data: \(data)")
                    if let contentType = response.response?.allHeaderFields["Content-Type"] as? String,
                       contentType.contains("application/json") {
                        if let jsonString = String(data: data, encoding:.utf8) {
                            print("JSON Response: \(jsonString)")
                            if let jsonData = jsonString.data(using:.utf8) {
                                do {
                                    let decoder = JSONDecoder()
                                    let addressResponse = try decoder.decode(AddressListResponse.self, from: jsonData)
                                    completion(.success(addressResponse.addresses))
                                } catch {
                                    print("Error decoding JSON: \(error.localizedDescription)")
                                    completion(.failure(error))
                                }
                            } else {
                                print("Invalid JSON response")
                                completion(.failure(NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey:"Invalid JSON response"])))
                            }
                        } else {
                            print("Invalid JSON response")
                            completion(.failure(NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey:"Invalid JSON response"])))
                        }
                    } else {
                        print("Received non json response: \(String(data: data, encoding:.utf8) ?? "")")
                        let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey:"Unexpected non json response"])
                        completion(.failure(error))
                    }
                case.failure(let error) :
                    print("Request failed: \(error)")
                    completion(.failure(error))
                }
            }*/
    }
    
}

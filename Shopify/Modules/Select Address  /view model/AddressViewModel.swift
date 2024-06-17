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
        let customerID = Authorize.getCustomerIDFromUserDefaults()
        print("customerID: \(customerID!)")
        
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
            let jsonData = try JSONSerialization.data(withJSONObject: addressDict, options: [])
            let addition = "\(customerID!)/addresses.json"
            
            NetworkManager.postDataToApi(endpoint: .addressCastomer, rootOfJson: .address, body: jsonData, addition: addition) { data, error in
                if let error = error {
                    print("Request failed: \(error)")
                    completion(.failure(error))
                } else if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON Response: \(jsonString)")
                    }
                    do {
                        let decoder = JSONDecoder()
                        let addressResponse = try decoder.decode(AddressResponse.self, from: data)
                        let newAddress = addressResponse.customer_address
                        self.addresses.append(newAddress)
                        completion(.success(newAddress))
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            print("Error serializing json: \(error)")
            completion(.failure(error))
        }
    }
    
    func getAllAddresses(completion: @escaping (Swift.Result<[Address], Error>) -> Void) {
        let customerID = Authorize.getCustomerIDFromUserDefaults()
        print("customerID: \(customerID!)")
        
        let addition = "\(customerID!)/addresses.json"
        
        NetworkManager.fetchDataFromApi(endpoint: .addressCastomer, rootOfJson: .address, addition: addition) { data, error in
            if let error = error {
                print("Request failed: \(error)")
                completion(.failure(error))
            } else if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response: \(jsonString)")
                }
                do {
                    let decoder = JSONDecoder()
                    let addressResponse = try decoder.decode([Address].self, from: data)
                    self.addresses = addressResponse
                    completion(.success(addressResponse))
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    
    func deleteAddress(_ address: Address, completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        let customerID = Authorize.getCustomerIDFromUserDefaults()
        print("customerID: \(customerID!)")
        
        let addition = "\(customerID!)/addresses/\(address.id).json"
        
        NetworkManager.deleteResource(endpoint: .addressCastomer, rootOfJson: .address, addition: addition) { data, error in
            if let error = error {
                print("Error deleting address: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Address deleted successfully")
                completion(.success(()))
            }
        }
    }
    
    
    
    
    func updateAddress(_ address: Address, completion: @escaping (Swift.Result<AddressResponse, Error>) -> Void) {
        guard let customerID = Authorize.getCustomerIDFromUserDefaults() else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Customer ID is nil"])
            print("Error: Customer ID is nil")
            completion(.failure(error))
            return
        }
        
        guard address.id != 0 else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Address ID is invalid"])
            print("Error: Address ID is invalid")
            completion(.failure(error))
            return
        }
        
        let addressDict: [String: Any] = [
            "address": [
                "address1": address.address1,
                "phone": address.phone ?? "",
                "city": address.city,
                "country": address.country,
                "zip": address.zip ?? "",
                "default": address.isDefault
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: addressDict, options: [])
            let additionParam = "\(customerID)/addresses/\(address.id).json"
            
            NetworkManager.updateResource(endpoint: .addressCastomer, rootOfJson: .address, body: jsonData, addition: additionParam) { data, error in
                if let error = error {
                    print("Failed to update address: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let responseData = data else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in response"])
                    print("Error: No data in response")
                    completion(.failure(error))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(AddressResponse.self, from: responseData)
                    
                    if let index = self.addresses.firstIndex(where: { $0.id == response.customer_address.id }) {
                        self.addresses[index] = response.customer_address
                    }
                    
                    completion(.success(response))
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(.failure(error))
                }
            }
        } catch {
            print("Failed to serialize address dictionary: \(error)")
            completion(.failure(error))
        }
    }
}

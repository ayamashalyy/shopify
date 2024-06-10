//
//  ViewModel.swift
//  Shopify
//
//  Created by mayar on 10/06/2024.
//

import Foundation

class ViewModel {
    func signUp(email: String, firstName: String, lastName: String, verifiedEmail: Bool, tags: String, completion: @escaping (Bool) -> Void) {
        let newCustomer = Customer(
            email: email,
            firstName: firstName,
            lastName: lastName,
            verifiedEmail: verifiedEmail,
            tags: tags,
            password: tags,
            passwordConfirmation: tags
        )
        
        let customerRequest = CustomerRequest(customer: newCustomer)
        
        // Encode the customerRequest
        Decoding.encodeData(object: customerRequest) { jsonData, encodeError in
            guard let jsonData = jsonData, encodeError == nil else {
                print("Error encoding customer data:", encodeError?.localizedDescription ?? "Unknown error")
                completion(false)
                return
            }
            
            NetworkManager.postDataToApi(endpoint: .customers, rootOfJson: .customer, body: jsonData) { data, error in
                guard let data = data, error == nil else {
                    print("Error fetching customer data:", error?.localizedDescription ?? "Unknown error")
                    completion(false)
                    return
                }
                
                // Print the raw data received from the server
                if let jsonString = String(data: data, encoding: .utf8) {
                 //   print("Raw JSON response: \(jsonString)")
                }
                
                // Decode the response
                Decoding.decodeData(data: data, objectType: CustomerResponse.self) { customerResponse, decodeError in
                    if let customerResponse = customerResponse {
                        print("New customer created with ID: \(customerResponse.customer.id ?? -1)")
                        completion(true)
                    } else {
                        print("Error decoding customer data:", decodeError?.localizedDescription ?? "Unknown error")
                        completion(false)
                    }
                }
            }
        }
    }
}

//
//  LoginViewModel.swift
//  Shopify
//
//  Created by mayar on 09/06/2024.
//

import Foundation

class LoginViewModel {

    func isACustomer(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        // Call getProductDetails function here with a specific id if needed
        
        NetworkManager.fetchDataFromApi(endpoint: .customers, rootOfJson: .customers) { data, error in
            guard let data = data, error == nil else {
                print("Error fetching customer data:", error?.localizedDescription ?? "Unknown error")
                completion(false) // Notify the caller that an error occurred
                return
            }
            print("Data received from API:", data)

            Decoding.decodeData(data: data, objectType: [Customer].self) { [weak self] (allCustomers, decodeError) in
                guard let self = self else {
                    completion(false) 
                    return
                }
                print("all customers: \(allCustomers)")
                
                if let allCustomers = allCustomers {
                    let isCustomer = allCustomers.contains { $0.email == email && $0.tags == password }
                    completion(isCustomer)
                } else {
                    print("Error decoding customer data:", decodeError?.localizedDescription ?? "Unknown error")
                    completion(false)
                }
            }
        }
    }
}

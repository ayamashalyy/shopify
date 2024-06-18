//
//  Auth Manager.swift
//  Shopify
//
//  Created by mayar on 16/06/2024.
//

import Foundation
import FirebaseAuth

final class AuthenticationManger {
    
    
    static func createUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {
                completion(false, "User creation failed.")
                return
            }
            
            user.sendEmailVerification { error in
                if let error = error {
                    // Handle error
                    print("Error sending verification email: \(error.localizedDescription)")
                    completion(false, error.localizedDescription)
                    return
                }
                
                completion(true, nil)
            }
        }
    }
}

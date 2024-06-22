//
//  googleViewModel.swift
//  Shopify
//
//  Created by mayar on 21/06/2024.
//

import Foundation

class GoogleViewModel {
    
    static func handleGoogleEmail( googleEmail: String, firstName: String , lastName: String) {
        GoogleViewModel.siginInWithGoogleEmail(googleEmail: googleEmail , firstName: firstName ,lastName: lastName ){ success in
            if success {
                print("handle goole data succesfully")
                // navigation
            }
            else {
                print("No user email found")
            }
        }
    }
    
    static func siginInWithGoogleEmail( googleEmail: String, firstName: String , lastName: String,completion: @escaping (Bool)-> Void ) {
        let siginUpviewModel = ViewModel()
        let loginViewModel = LoginViewModel()
        
        siginUpviewModel.createCustomer(email: googleEmail, firstName: firstName, lastName:lastName, tags: ""){
            
            customerCreationSuccess in
            if customerCreationSuccess {
                // that mean it creat acount which is first time enter
                print(" customerCreationSuccess here creat cutomer and draft order")
                completion(true)
            }
            else {
                print(" aleardy user deal with it as normal login")
                
                // aleardy user deal with it as normal login
                loginViewModel.isACustomer(email: googleEmail, password: ""){ isAcusotmer in
                    
                    if isAcusotmer{
                        print("he is a cusotmer ")
                        
                        completion(true)
                    }
                    else {
                        print("not created and not isAcusotmer ")
                    }
                }
            }
        }
    }
}

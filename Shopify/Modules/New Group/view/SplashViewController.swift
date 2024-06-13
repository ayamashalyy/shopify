//
//  SplashViewController.swift
//  Shopify
//
//  Created by aya on 03/06/2024.
//

import UIKit

class SplashViewController: UIViewController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
         // for codding only the next line:
          // Authorize.logout()
         //  self.checkCustomerID()
            Navigation.ToSearch(from: self, comeFromHome: true , products: [])
          
        }
    }
    
    func checkCustomerID() {
     var  customerID = Authorize.getCustomerIDFromUserDefaults()
        if customerID == 0  {
            print(" nottttt customerID")
            Navigation.ToALogin(from: self)
        } else {
            print("customerID\(customerID)")
            Navigation.ToHome(from: self)
       }
    }
    
}

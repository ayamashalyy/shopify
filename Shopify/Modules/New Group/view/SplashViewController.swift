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
            self.checkCustomerID()
            
        }
    }
    
    
    
    func checkCustomerID() {
        if let customerID = Authorize.getCustomerIDFromUserDefaults() {
            Navigation.ToHome(from: self)
        } else {
            Navigation.ToALogin(from: self)
       }
    }
    
}

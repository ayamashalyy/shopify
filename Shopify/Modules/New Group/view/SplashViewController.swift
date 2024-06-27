//
//  SplashViewController.swift
//  Shopify
//
//  Created by aya on 03/06/2024.
//

import UIKit

class SplashViewController: UIViewController {
    let viewModel = ShoppingCartViewModel()
    let settingsViewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
         // for codding only the next line:


    //  Authorize.logout()
      self.checkCustomerID()
        }       
    }

    func checkCustomerID() {
     var  isRegistedCustomer  = Authorize.isRegistedCustomer()
        if isRegistedCustomer  {
            Navigation.ToHome(from: self)
            settingsViewModel.saveCurrencySelection(.EGP)
        } else {
            Navigation.ToALogin(from: self)
            settingsViewModel.saveCurrencySelection(.EGP)
       }
    }
    
}



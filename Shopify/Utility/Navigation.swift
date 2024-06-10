//
//  Navigation.swift
//  Shopify
//
//  Created by mayar on 07/06/2024.
//

import Foundation
import UIKit

class Navigation {
    
//Navigation.ToProduct(productId: "someProductId", from: self)
//    Navigation.ToSearch(from: self)
//    Navigation.ToAllFavourite(from: self)
//    Navigation.ToOrders(from: self)
    
    
    static func ToAllFavourite(from viewController: UIViewController) {
         let storyboard = UIStoryboard(name: "third", bundle: nil)
         if let vc = storyboard.instantiateViewController(withIdentifier: "AllFavViewController") as? AllFavViewController {
             vc.modalPresentationStyle = .fullScreen
             viewController.present(vc, animated: true, completion: nil)
         }
     }
    
    static func toSignUpViewController(from viewController: UIViewController) {
         let storyboard = UIStoryboard(name: "third", bundle: nil)
         if let vc = storyboard.instantiateViewController(withIdentifier: "signUpViewController") as? signUpViewController {
             vc.modalPresentationStyle = .fullScreen
             viewController.present(vc, animated: true, completion: nil)
         }
     }
    
    static func ToHome(from viewController: UIViewController) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if let vc = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController {
             vc.modalPresentationStyle = .fullScreen
             viewController.present(vc, animated: true, completion: nil)
         }
     }
    
    static func ToProduct(productId: String, from viewController: UIViewController) {
           let storyboard = UIStoryboard(name: "third", bundle: nil)
           if let vc = storyboard.instantiateViewController(withIdentifier: "productDetails") as? ProductViewController {
               print("to product")
               vc.productId = productId
               vc.modalPresentationStyle = .fullScreen

               viewController.present(vc, animated: true, completion: nil)
           }else {
               print("to product")
           }
       }


    static func ToSearch(from viewController: UIViewController) {
           let storyboard = UIStoryboard(name: "third", bundle: nil)
           if let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
               vc.modalPresentationStyle = .fullScreen
               viewController.present(vc, animated: true, completion: nil)
           }
       }
     

        static func ToOrders(from viewController: UIViewController) {
            let storyboard = UIStoryboard(name: "Second", bundle: nil)
            if let ShoppingCartViewController = storyboard.instantiateViewController(withIdentifier: "ShoppingCartViewController") as? ShoppingCartViewController {
                ShoppingCartViewController.modalPresentationStyle = .fullScreen
                viewController.present(ShoppingCartViewController, animated: true, completion: nil)
            }
        }
    
    static func ToALogin(from viewController: UIViewController) {
        print("in navigation to login")
        let storyboard = UIStoryboard(name: "third", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true, completion: nil)
     }
        
}

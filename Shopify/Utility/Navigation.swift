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
       
        static func ToProduct(productId: String, from viewController: UIViewController) {
            let storyboard = UIStoryboard(name: "third", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "productDetails") as! ProductViewController
                vc.productId = productId
                viewController.navigationController?.pushViewController(vc, animated: true)
            
        }

        static func ToSearch(from viewController: UIViewController) {
            let storyboard = UIStoryboard(name: "third", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                viewController.navigationController?.pushViewController(vc, animated: true)
            
        }

        static func ToAllFavourite(from viewController: UIViewController) {
            let storyboard = UIStoryboard(name: "third", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "AllFavViewController") as! AllFavViewController
                viewController.navigationController?.pushViewController(vc, animated: true)
            
        }

        static func ToOrders(from viewController: UIViewController) {
            let storyboard = UIStoryboard(name: "Second", bundle: nil)
//             let vc = storyboard.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
//                viewController.navigationController?.pushViewController(vc, animated: true)
//            
        }
    
    static func ToALogin(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "third", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    static func toCollectionView(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "third", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

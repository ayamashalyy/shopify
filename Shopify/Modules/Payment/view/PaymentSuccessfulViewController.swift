//
//  PaymentSuccessfulViewController.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//

import UIKit

class PaymentSuccessfulViewController: UIViewController {
    @IBOutlet weak var backoHome: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupbackoHomeButton()
        
    }
    
    func setupbackoHomeButton() {
        backoHome.backgroundColor = UIColor(hex: "#FF7D29")
        backoHome.setTitleColor(UIColor.white, for: .normal)
        backoHome.layer.cornerRadius = 10
        backoHome.clipsToBounds = true
    }
    
    @IBAction func backoHome(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let HomeViewController = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController{
            HomeViewController.modalPresentationStyle = .fullScreen
            present(HomeViewController, animated: true, completion: nil)
        }
    }
}



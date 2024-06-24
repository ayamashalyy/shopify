//
//  MeGuestViewController.swift
//  Shopify
//
//  Created by aya on 24/06/2024.
//

import UIKit

class MeGuestViewController: UIViewController {

    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signUp: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginButton()
        setupSignUpButton()
    }
    
    
    func setupLoginButton() {
        login.backgroundColor = UIColor(hex: "#FF7D29")
        login.setTitleColor(UIColor.white, for: .normal)
        login.layer.cornerRadius = 10
        login.clipsToBounds = true
    }
    
    func setupSignUpButton() {
        signUp.backgroundColor = UIColor(hex: "#FF7D29")
        signUp.setTitleColor(UIColor.white, for: .normal)
        signUp.layer.cornerRadius = 10
        signUp.clipsToBounds = true
    }

    @IBAction func login(_ sender: UIButton) {
    }
    
    @IBAction func signUp(_ sender: UIButton) {
    }
    
}

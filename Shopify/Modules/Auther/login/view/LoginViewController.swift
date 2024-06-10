//
//  LoginViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loginViewModel = LoginViewModel()
    }
    
    
    var loginViewModel : LoginViewModel?
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    
    
    
    @IBAction func signUpBtx(_ sender: UIButton) {
        print("singup")
        // navigate is done througth storeboard
    }
    
    @IBAction func loginBtx(_ sender: UIButton) {
            print("loginBtx")
            
            guard let email = emailTxt.text, !email.isEmpty else {
                showAlert(message: "Please enter your email.")
                return
            }
            
            guard let password = passwordTxt.text, !password.isEmpty else {
                showAlert(message: "Please enter your password.")
                return
            }
            
            loginViewModel?.isACustomer(email: email, password: password) { isACustomer in
                if isACustomer {
                    print("Is a customer, go to home")
                    Navigation.ToHome(from: self)
                } else {
                    self.showAlert(message: "Sorry, you do not have an account. Click on Sign up.")
                }
            }
    }
    
    @IBAction func guestButton(_ sender: UIButton) {
            print("guestButton")
        if let customerID = Authorize.getCustomerIDFromUserDefaults() {
            print("Customer ID:", customerID)
        }

            let alertController = UIAlertController(title: "Alert", message: "As A Guest you can not make orders or set products as favourites", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                Navigation.ToHome(from: self)
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
   }

        
    
    func setUpUI (){
        guestBtn.backgroundColor = UIColor(hex: "#FF7D29")
        guestBtn.layer.cornerRadius = 8
        loginButton.backgroundColor = UIColor(hex: "#FF7D29")
        loginButton.layer.cornerRadius = 8
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

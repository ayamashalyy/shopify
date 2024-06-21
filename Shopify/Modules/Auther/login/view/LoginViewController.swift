//
//  LoginViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loginViewModel = LoginViewModel()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        

       
    }
    
    @IBOutlet weak var siginUP: UIButton!
    @IBOutlet weak var siginInGoogle: GIDSignInButton!

    var loginViewModel : LoginViewModel?
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var showHideButton: UIButton!
        
        var isPasswordVisible = false
    
    @IBAction func signUpBtx(_ sender: UIButton) {
        print("singup")
        Navigation.toSignUpViewController(from: self)
    }
    
    
    @IBAction func showHideButtonTapped(_ sender: UIButton) {
           isPasswordVisible.toggle()
           let buttonImage = isPasswordVisible ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash.fill")
           showHideButton.setImage(buttonImage, for: .normal)
           passwordTxt.isSecureTextEntry = !isPasswordVisible
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
            
            loginViewModel?.isValidedEmail(email: email, password: password) { isACustomer in
                if isACustomer {
                    print("Is a customer, go to home")
                    Navigation.ToHome(from: self)
                } else {
                    self.showAlert(message: "Please create acount and verify it througth the email,then login again")
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
        
        passwordTxt.isSecureTextEntry = true
        let orangeColor = UIColor(hex: "#FFA500")
               showHideButton.setImage(UIImage(systemName: "eye.slash.fill")?.withTintColor(orangeColor), for: .normal)

    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

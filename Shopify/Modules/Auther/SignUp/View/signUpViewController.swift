//
//  signUpViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class signUpViewController: UIViewController {

    var signUPviewModel : SignUPViewModel?
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var secondName: UITextField!
    
    @IBOutlet weak var pass: UITextField!
    
    @IBOutlet weak var confirmPass: UITextField!
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        print("insignin screen after press signup button")
        // Validate fields
        guard let firstNameText = firstName.text, !firstNameText.isEmpty else {
            print("firstNameText")

            showAlert(message: "First name is required.")
            return
        }
        
        guard let emailText = email.text, !emailText.isEmpty else {
            showAlert(message: "Email is required.")
            return
        }
        if !isValidEmail(emailText) {
             showAlert(message: "Email is not in correct format")
             return
         }
        
        guard let lastNameText = secondName.text, !lastNameText.isEmpty else {
            showAlert(message: "Last name is required.")
            return
        }
        
        guard let passText = pass.text, !passText.isEmpty else {
            showAlert(message: "Password is required.")
            return
        }
        
        guard let confirmPassText = confirmPass.text, !confirmPassText.isEmpty else {
            showAlert(message: "Password confirmation is required.")
            return
        }
        
        guard passText == confirmPassText else {
            showAlert(message: "Passwords do not match.")
            return
        }
       
        // Check if password meets minimum length requirement
         if passText.count < 5 {
             showAlert(message: "Password must be at least 5 characters long")
             return
         }
        
       
        // make it return response and accrding
        // show alert what result and if create and clock ok  Navigation.
        signUPviewModel?.signUp(id: 0, email: emailText, firstName: firstNameText, lastName: lastNameText, verifiedEmail: true, tags: passText)

    }
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setUpUI()
            signUPviewModel = SignUPViewModel()
        }
        
    func setUpUI (){
        signUpButton.backgroundColor = UIColor(hex: "#FF7D29")
        signUpButton.layer.cornerRadius = 8
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

     private func showAlert(message: String) {
            let alertController = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
}

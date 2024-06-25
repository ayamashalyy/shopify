//
//  signUpViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class signUpViewController: UIViewController {
    
    var settingsViewModel = SettingsViewModel()

    @IBAction func dismis(_ sender: Any) {
        dismiss(animated: true)
    }
    
    var signUPviewModel : ViewModel?
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var secondName: UITextField!
    
    @IBOutlet weak var pass: UITextField!
    
    @IBOutlet weak var confirmPass: UITextField!
    
    @IBOutlet weak var showHidePassButton: UIButton!
    
    @IBOutlet weak var showHideConfirmPassButton: UIButton!
        
        var isPasswordVisible = false
        var isConfirmPasswordVisible = false
    
    @IBAction func showHidePassButtonTapped(_ sender: UIButton) {
          isPasswordVisible.toggle()
          let buttonImage = isPasswordVisible ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash.fill")
          showHidePassButton.setImage(buttonImage, for: .normal)
          pass.isSecureTextEntry = !isPasswordVisible
      }
      
      @IBAction func showHideConfirmPassButtonTapped(_ sender: UIButton) {
          isConfirmPasswordVisible.toggle()
          let buttonImage = isConfirmPasswordVisible ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash.fill")
          showHideConfirmPassButton.setImage(buttonImage, for: .normal)
          confirmPass.isSecureTextEntry = !isConfirmPasswordVisible
      }
      
       
    @IBAction func signUpBtn(_ sender: UIButton) {
        guard let firstNameText = firstName.text, !firstNameText.isEmpty else {
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
       
         if passText.count < 5 {
             showAlert(message: "Password must be at least 5 characters long")
             return
         }
        
        if  CheckNetworkReachability.checkNetworkReachability(){
            
            signUPviewModel?.signUp( email: emailText, firstName: firstNameText, lastName: lastNameText, tags: passText) { createdNewCustomer in
                if createdNewCustomer {
                    self.settingsViewModel.saveCurrencySelection(.USD)
                    
                    self.showAlert(message: "Pleace check youe email and make verifcation, then login"){action in
                        Navigation.ToALogin(from: self)
                    }
                    
                } else {
                    self.showAlert(message: "Sorry, Try reregiste with different email")
                }
            }
        }else {
            showAlert(message: "Connect with network then login")
        }
        
        
    }
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setUpUI()
            signUPviewModel = ViewModel()
        }
        
    func setUpUI (){
        signUpButton.backgroundColor = UIColor(hex: "#FF7D29")
        signUpButton.layer.cornerRadius = 8
        pass.isSecureTextEntry = true
               confirmPass.isSecureTextEntry = true
               
       let orangeColor = UIColor(hex: "#FF7D29") 
       showHidePassButton.setImage(UIImage(systemName: "eye.slash.fill")?.withTintColor(orangeColor), for: .normal)
       showHideConfirmPassButton.setImage(UIImage(systemName: "eye.slash.fill")?.withTintColor(orangeColor), for: .normal)
          

    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

   
    private func showAlert(message: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}

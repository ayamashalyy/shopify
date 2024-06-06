//
//  LoginViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    
    
    
    @IBAction func signUpBtx(_ sender: UIButton) {
        print("singup")
    }
    
    @IBAction func loginBtx(_ sender: UIButton) {
        print("loginBtx")
    }
    
    @IBAction func guestButton(_ sender: UIButton) {
        print("guestButton")

    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI (){
        guestBtn.backgroundColor = UIColor(hex: "#FF7D29")
        guestBtn.layer.cornerRadius = 8
        loginButton.backgroundColor = UIColor(hex: "#FF7D29")
        loginButton.layer.cornerRadius = 8
//        signUpButton.backgroundColor = UIColor(hex: "#FF7D29")
//        signUpButton.layer.cornerRadius = 8
    }

}

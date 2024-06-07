//
//  signUpViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class signUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var pass: UITextField!
    
    @IBOutlet weak var confirmPass: UITextField!
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        print("insignin screen after press signup button")
        
    }
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setUpUI()
        }
        
    func setUpUI (){
        signUpButton.backgroundColor = UIColor(hex: "#FF7D29")
        signUpButton.layer.cornerRadius = 8
   
    }
}

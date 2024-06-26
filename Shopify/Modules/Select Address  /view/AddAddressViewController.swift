//
//  AddAddressViewController.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//



import UIKit

class AddAddressViewController: UIViewController {
    
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    @IBOutlet weak var addAddressButton: UIButton!
    
    var addAddressAction: ((String, String, String, String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    func setupButtons() {
        addAddressButton.backgroundColor = UIColor(hex: "#FF7D29")
        addAddressButton.setTitleColor(UIColor.white, for: .normal)
        addAddressButton.layer.cornerRadius = 10
        addAddressButton.clipsToBounds = true
    }
    
    @IBAction func addAddress(_ sender: UIButton) {
        
        guard CheckNetworkReachability.checkNetworkReachability() else {
            showNoInternetAlert()
            return
        }
        
        guard let address = addressTF.text, !address.isEmpty,
              let phone = phoneTF.text, !phone.isEmpty,
              let city = cityTF.text, !city.isEmpty,
              let country = countryTF.text, !country.isEmpty,
              let zip = zipTF.text, !zip.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        guard isValidEgyptianPhone(phone) else {
            showAlert(title: "Invalid Phone Number", message: "Please enter a valid Egyptian phone number (010, 011, 012, or 015 followed by 8 digits).")
            return
        }
        
        addAddressAction?(address, phone, city, country, zip)
        showAlert(title: "Success", message: "Address added successfully")
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if title == "Success" {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func isValidEgyptianPhone(_ phone: String) -> Bool {
        let phoneRegex = "^(010|011|012|015)[0-9]{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    @IBAction func backToSelectAddress(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

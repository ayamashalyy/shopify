//
//  EditAddressViewController.swift
//  Shopify
//
//  Created by aya on 21/06/2024.
//

import UIKit

class EditAddressViewController: UIViewController {
    
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    @IBOutlet weak var editAddressButton: UIButton!
    
    var viewModel = AddressViewModel()
    
    var editCompletion: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        fillAddressFields()
    }
    
    func setupButtons() {
        editAddressButton.backgroundColor = UIColor(hex: "#FF7D29")
        editAddressButton.setTitleColor(UIColor.white, for: .normal)
        editAddressButton.layer.cornerRadius = 10
        editAddressButton.clipsToBounds = true
    }
    
    func fillAddressFields() {
        guard let address = viewModel.getDefaultAddress() else { return }
        addressTF.text = address.address1
        phoneTF.text = address.phone
        cityTF.text = address.city
        countryTF.text = address.country
        zipTF.text = address.zip
    }
    
    @IBAction func editAddress(_ sender: UIButton) {
        guard let address = viewModel.getDefaultAddress() else { return }
        guard validateFields() else { return }
        let updatedAddress = Address(id: address.id,
                                     address1: addressTF.text ?? "",
                                     phone: phoneTF.text ?? "",
                                     city: cityTF.text ?? "",
                                     country: countryTF.text ?? "",
                                     zip: zipTF.text ?? "",
                                     isDefault: address.isDefault)
        
        viewModel.updateAddress(updatedAddress) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.showSuccessAlert()
                    self?.editCompletion?()
                }
            case .failure(let error):
                print("Failed to update address: \(error.localizedDescription)")
            }
        }
    }
    
    func validateFields() -> Bool {
        if addressTF.text?.isEmpty ?? true {
            showAlert(message: "Please enter address")
            return false
        }
        if phoneTF.text?.isEmpty ?? true {
            showAlert(message: "Please enter phone number")
            return false
        }
        if !isValidEgyptianPhone(phoneTF.text ?? "") {
            showAlert(message: "Please enter a valid Egyptian phone number")
            return false
        }
        if cityTF.text?.isEmpty ?? true {
            showAlert(message: "Please enter city")
            return false
        }
        if countryTF.text?.isEmpty ?? true {
            showAlert(message: "Please enter country")
            return false
        }
        if zipTF.text?.isEmpty ?? true {
            showAlert(message: "Please enter ZIP code")
            return false
        }
        return true
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Address updated successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.dismiss(animated: true, completion: nil)
        present(alert, animated: true, completion: nil)
    }
    
    func isValidEgyptianPhone(_ phone: String) -> Bool {
        let phoneRegex = "^(010|011|012|015)[0-9]{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    @IBAction func backToSelectAddress(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}

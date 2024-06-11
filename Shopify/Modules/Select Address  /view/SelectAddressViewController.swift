//
//  SelectAddressViewController.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//

import UIKit



class SelectAddressViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    private let viewModel: AddressViewModel
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navToPlaceOrder: UIButton!
    
    init(viewModel: AddressViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SelectAddressViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = AddressViewModel()
        super.init(coder: coder)
    }
    
    @IBAction func addAddress(_ sender: UIBarButtonItem) {
        showAddAddressAlert()
    }
    
    private func showAddAddressAlert() {
        let alert = UIAlertController(title: "Add Address", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Address"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Phone"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "City"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Country"
            textField.text = "Egypt"
            textField.isUserInteractionEnabled = false
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Zip Code"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add Address", style: .default) { (_) in
            guard let address = alert.textFields?.first?.text,!address.isEmpty,
                  let phone = alert.textFields?[1].text, !phone.isEmpty,
                  let city = alert.textFields?[2].text,!city.isEmpty,
                  let country = alert.textFields?[3].text,!country.isEmpty,
                  let zip = alert.textFields?[4].text,!zip.isEmpty else {
                let emptyFieldAlert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                emptyFieldAlert.addAction(okAction)
                self.present(emptyFieldAlert, animated: true, completion: nil)
                return
            }
            if !self.isValidEgyptianPhone(phone) {
                let invalidPhoneAlert = UIAlertController(title: "Invalid Phone Number", message: "Please enter a valid Egyptian phone number (+20xxxxxxxxx).", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                invalidPhoneAlert.addAction(okAction)
                self.present(invalidPhoneAlert, animated: true, completion: nil)
                return
            }
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            let newAddress = Address(id: self.viewModel.addresses.count + 1, address1: address, phone: phone, city: city, country: country, zip: zip, isDefault: false)
            self.viewModel.addAddress(newAddress) { result in
                switch result {
                case .success(let address):
                    print("Address added successfully: \(address)")
                    let successAlert = UIAlertController(title: "Success", message: "Address added successfully", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.tableView.reloadData()
                    }
                    
                    successAlert.addAction(okAction)
                    self.present(successAlert, animated: true, completion: nil)
                case .failure(let error):
                    print("Failed to post address: \(error)")
                    let postFailureAlert = UIAlertController(title: "Error", message: "Failed to post address: \(error)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    postFailureAlert.addAction(okAction)
                    self.present(postFailureAlert, animated: true, completion: nil)
                    
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SelectAddressCell", bundle: nil), forCellReuseIdentifier: "SelectAddressCell")
        navToPlaceOrder.backgroundColor = UIColor(hex: "#FF7D29")
        navToPlaceOrder.layer.cornerRadius = 8
        
    }
    func isValidEgyptianPhone(_ phone: String) -> Bool {
        let phoneRegex = "^\\+20[0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllAddresses { [weak self] result in
            switch result {
            case.success(let addresses):
                self?.viewModel.addresses = addresses
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case.failure(let error):
                print("Error retrieving addresses: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Error", message: "Failed to retrieve addresses: \(error.localizedDescription)", preferredStyle:.alert)
                let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAddressCell", for: indexPath) as? SelectAddressCell else {
            return UITableViewCell()
        }
        
        let address = viewModel.addresses[indexPath.row]
        cell.addressLabel.text = address.address1
        cell.phoneLabel.text = address.phone
        cell.cityLabel.text = address.city
        cell.countryLabel.text = address.country
        cell.zipCodeLabel.text = address.zip
        if address.isDefault ?? true {
            cell.containerView.backgroundColor = UIColor.white
            cell.containerView.layer.borderColor = UIColor(hex: "#FF7D29").cgColor
            cell.containerView.layer.borderWidth = 1.0
            cell.containerView.layer.cornerRadius = 10.0
            cell.containerView.layer.shadowColor = UIColor.black.cgColor
            cell.containerView.layer.shadowOpacity = 0.25
            cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.containerView.layer.shadowRadius = 2.0
        } else {
            cell.containerView.backgroundColor = UIColor.white
            cell.containerView.layer.borderColor = UIColor.clear.cgColor
            cell.containerView.layer.borderWidth = 1.0
            cell.containerView.layer.cornerRadius = 10.0
            cell.containerView.layer.shadowColor = UIColor.clear.cgColor
            cell.containerView.layer.shadowOpacity = 0.25
            cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.containerView.layer.shadowRadius = 2.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let address = viewModel.addresses[indexPath.row]
            self.showConfirmDeleteAlert(address: address, indexPath: indexPath)
        }
    }
    
    func showConfirmDeleteAlert(address: Address, indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this address?", preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style:.cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style:.destructive) { [weak self] _ in
            self?.viewModel.deleteAddress(address) { result in
                switch result {
                case.success:
                    print("Address deleted successfully")
                    self?.viewModel.addresses.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with:.fade)
                    self?.showAlert(title: "Success", message: "Address deleted successfully")
                case.failure(let error):
                    print("Error deleting address: \(error)")
                    self?.showAlert(title: "Error", message: "Failed to delete address: \(error.localizedDescription)")
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let address = viewModel.addresses[indexPath.row]
        
        let alert = UIAlertController(title: "Edit Address", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Address"
            textField.text = address.address1
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Phone"
            textField.text = address.phone
        }
        
        alert.addTextField { textField in
            textField.placeholder = "City"
            textField.text = address.city
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Country"
            textField.text = "Egypt"
            textField.isUserInteractionEnabled = false
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Zip Code"
            textField.text = address.zip
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
            guard let address1 = alert.textFields?[0].text, !address1.isEmpty,
                  let phone = alert.textFields?[1].text, !phone.isEmpty,
                  let city = alert.textFields?[2].text, !city.isEmpty,
                  let country = alert.textFields?[3].text, !country.isEmpty,
                  let zip = alert.textFields?[4].text, !zip.isEmpty else {
                self.showAlert(title: "Error", message: "Please fill in all fields")
                return
            }
            if !self.isValidEgyptianPhone(phone) {
                let invalidPhoneAlert = UIAlertController(title: "Invalid Phone Number", message: "Please enter a valid Egyptian phone number (+20xxxxxxxxx).", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                invalidPhoneAlert.addAction(okAction)
                self.present(invalidPhoneAlert, animated: true, completion: nil)
                return
            }
            
            let updatedAddress = Address(id: address.id, address1: address1, phone: phone, city: city, country: country, zip: zip, isDefault: address.isDefault ?? false)
            
            self.viewModel.updateAddress(updatedAddress) { result in
                switch result {
                case .success(let updatedAddress):
                    print("Address updated successfully: \(updatedAddress)")
                    self.tableView.reloadData()
                    self.showAlert(title: "Success", message: "Address updated successfully")
                case .failure(let error):
                    print("Failed to update address: \(error)")
                    self.showAlert(title: "Error", message: "Failed to update address: \(error.localizedDescription)")
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(updateAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    @IBAction func backToShoppingCart(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    @IBAction func navToPlaceOrder(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let PlaceOrderViewController = storyboard.instantiateViewController(withIdentifier: "PlaceOrderViewController") as? PlaceOrderViewController {
            PlaceOrderViewController.modalPresentationStyle = .fullScreen
            present(PlaceOrderViewController, animated: true, completion: nil)
        }
    }
    
}

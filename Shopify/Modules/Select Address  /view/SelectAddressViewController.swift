//
//  SelectAddressViewController.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//

import UIKit



class SelectAddressViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate, SelectAddressCellProtocol {
    
    
    private let viewModel: AddressViewModel
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navToPlaceOrder: UIButton!
    var address: String = ""
    var country: String = ""
    var phone: String = ""
    init(viewModel: AddressViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SelectAddressViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = AddressViewModel()
        super.init(coder: coder)
    }
    
    @IBAction func addAddress(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let addAddressVC = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController {
            addAddressVC.modalPresentationStyle = .overFullScreen
            
            addAddressVC.addAddressAction = { [weak self] (address, phone, city, country, zip) in
                let newAddress = Address(id: self?.viewModel.addresses.count ?? 0 + 1, address1: address, phone: phone, city: city, country: country, zip: zip, isDefault: false)
                
                self?.viewModel.addAddress(newAddress) { result in
                    switch result {
                    case .success(let address):
                        print("Address added successfully: \(address)")
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                            self?.showAlert(title: "Success", message: "Address added successfully")
                        }
                    case .failure(let error):
                        print("Failed to post address: \(error)")
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error", message: "Failed to post address: \(error.localizedDescription)")
                        }
                    }
                }
            }
            
            self.present(addAddressVC, animated: true, completion: nil)
        }
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
        if viewModel.addresses.isEmpty {
            let noAddressesImageView = UIImageView(image: UIImage(named: "no_items"))
            noAddressesImageView.contentMode = .scaleAspectFit
            tableView.backgroundView = noAddressesImageView
            return 0
        } else {
            tableView.backgroundView = nil
            return viewModel.addresses.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAddressCell", for: indexPath) as? SelectAddressCell else {
            return UITableViewCell()
        }
        
        var addressDefault = viewModel.addresses[indexPath.row]
        print("addressTest..............................\(addressDefault.isDefault)")
        cell.addressLabel.text = addressDefault.address1
        cell.phoneLabel.text = addressDefault.phone
        cell.cityLabel.text = addressDefault.city
        cell.countryLabel.text = addressDefault.country
        cell.zipCodeLabel.text = addressDefault.zip
        cell.indexPath = indexPath
        cell.delegate = self
        if addressDefault.isDefault {
            cell.containerView.backgroundColor = UIColor.white
            cell.containerView.layer.borderColor = UIColor(hex: "#FF7D29").cgColor
            cell.containerView.layer.borderWidth = 1.0
            cell.containerView.layer.cornerRadius = 10.0
            cell.containerView.layer.shadowColor = UIColor.black.cgColor
            cell.containerView.layer.shadowOpacity = 0.25
            cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.containerView.layer.shadowRadius = 2.0
            
            phone = addressDefault.phone ?? ""
            country = addressDefault.country
            address = addressDefault.address1
            
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
        let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this address?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.deleteAddress(address) { result in
                switch result {
                case .success:
                    print("Address deleted successfully")
                    self.viewModel.addresses.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.showAlert(title: "Success", message: "Address deleted successfully")
                    }
                case .failure(let error):
                    print("Error deleting address: \(error)")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Failed to delete address,Cannot delete the customer’s default address")
                    }
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        for i in 0..<viewModel.addresses.count {
            viewModel.addresses[i].isDefault = false
        }
        viewModel.addresses[indexPath.row].isDefault = true
        let selectedAddress = viewModel.addresses[indexPath.row]
        viewModel.updateAddress(selectedAddress) { [weak self] result in
            switch result {
            case .success(let updatedAddress):
                print("Address updated successfully: \(updatedAddress)")
                self?.phone = updatedAddress.customer_address.phone!
                self?.country = updatedAddress.customer_address.country
                self?.address = updatedAddress.customer_address.address1
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Failed to update address: \(error)")
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Failed to update address: \(error.localizedDescription)")
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    
    func editAddress(at indexPath: IndexPath) {
        guard let editAddressVC = storyboard?.instantiateViewController(withIdentifier: "EditAddressViewController") as? EditAddressViewController else {
            return
        }
        
        let selectedAddress = viewModel.addresses[indexPath.row]
        editAddressVC.modalPresentationStyle = .overFullScreen
        editAddressVC.viewModel = viewModel
        editAddressVC.editCompletion = { [weak self] in
            self?.tableView.reloadData()
        }
        
        present(editAddressVC, animated: true, completion: nil)
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
        if viewModel.addresses.isEmpty {
            showAlert(title: "No Address", message: "Please add an address before placing an order.")
        } else {
            let storyboard = UIStoryboard(name: "Second", bundle: nil)
            if let placeOrderViewController = storyboard.instantiateViewController(withIdentifier: "PlaceOrderViewController") as? PlaceOrderViewController {
                placeOrderViewController.modalPresentationStyle = .fullScreen
                
                placeOrderViewController.selectedAddress = address
                placeOrderViewController.selectedCountry = country
                placeOrderViewController.selectedPhone = phone
                
                
                present(placeOrderViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    
}

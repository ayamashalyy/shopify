//
//  SettingsViewController.swift
//  Shopify
//
//  Created by aya on 03/06/2024.
//

import UIKit

class SettingsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    let settings = ["Currency", "Address", "About Us","Contact Us"]
    let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUpUI()
    }
    
    func setUpUI(){
        profileImageView.image = UIImage(named: "profile")
        nameLabel.text = "Aya"
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.backgroundColor = UIColor(hex: "#FF7D29")
        logoutButton.layer.cornerRadius = 8
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settings[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        let disclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.right"))
        disclosureIndicator.tintColor = .black
        cell.accessoryView = disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if settings[indexPath.row] == "Currency" {
            presentCurrencySelectionAlert()
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        print("Log out tapped")
    }
    
    @IBAction func backToProfile(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func presentCurrencySelectionAlert() {
        let alert = UIAlertController(title: "Select Currency", message: nil, preferredStyle: .alert)
        
        let usdAction = UIAlertAction(title: "USD", style: .default) { _ in
            self.viewModel.saveCurrencySelection(.USD)
            print("USD selected")
        }
        let egpAction = UIAlertAction(title: "EGP", style: .default) { _ in
            self.viewModel.saveCurrencySelection(.EGP)
            print("EGP selected")
        }
        
        alert.addAction(usdAction)
        alert.addAction(egpAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Check the currently selected currency and add a checkmark to it
        if let selectedCurrency = viewModel.getSelectedCurrency() {
            switch selectedCurrency {
            case .USD:
                usdAction.setValue(true, forKey: "checked")
            case .EGP:
                egpAction.setValue(true, forKey: "checked")
            }
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

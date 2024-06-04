//
//  SelectAddressViewController.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//

import UIKit

struct Address {
    let address: String
    let phone: String
}

class SelectAddressViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    
    var addresses: [Address] = [
        Address(address: "123 Main St, Springfield", phone: "555-1234"),
        Address(address: "456 Elm St, Shelbyville", phone: "555-5678"),
        Address(address: "456 Elm St, Shelbyville", phone: "555-5678"),
        Address(address: "456 Elm St, Shelbyville", phone: "555-5678"),
        Address(address: "456 Elm St, Shelbyville", phone: "555-5678"),
        Address(address: "456 Elm St, Shelbyville", phone: "555-5678"),
        Address(address: "456 Elm St, Shelbyville", phone: "555-5678")
    ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addAddress(_ sender: UIBarButtonItem) {
        print("Added Address")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SelectAddressCell", bundle: nil), forCellReuseIdentifier: "SelectAddressCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAddressCell", for: indexPath) as? SelectAddressCell else {
            return UITableViewCell()
        }
        
        let address = addresses[indexPath.row]
        cell.addressLabel.text = address.address
        cell.phoneLabel.text = address.phone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Address: \(addresses[indexPath.row].address)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
}

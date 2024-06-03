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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUpUI()
    }
    
    func setUpUI(){
        profileImageView.image = UIImage(named: "profile")
        nameLabel.text = "Yennefer Doe"
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.backgroundColor = UIColor(hex: "#FF7D29")
        logoutButton.layer.cornerRadius = 8
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 1.9
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
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        print("Log out tapped")
    }
    
}

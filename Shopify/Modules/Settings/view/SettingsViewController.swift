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
    
    let settings = ["Currency", "Address", "About us"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpUI(){
        profileImageView.image = UIImage(named: "profile")
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        nameLabel.text = "Yennefer Doe"
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.backgroundColor = .orange
        logoutButton.layer.cornerRadius = 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settings[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        print("Log out tapped")
    }
    
}

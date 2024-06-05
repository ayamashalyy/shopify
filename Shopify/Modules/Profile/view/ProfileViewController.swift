//
//  ProfileViewController.swift
//  Shopify
//
//  Created by aya on 05/06/2024.
//

import UIKit

struct Order {
    let totalPrice: String
    let creationDate: String
    let shippedTo: String
    let phone: String
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var orders: [Order] = [
        Order(totalPrice: "$100", creationDate: "2023-05-01", shippedTo: "New York", phone: "123-456-7890"),
        Order(totalPrice: "$200", creationDate: "2023-06-01", shippedTo: "Los Angeles", phone: "098-765-4321")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: "OrderViewCell", bundle: nil), forCellReuseIdentifier: "OrderViewCell")
        tableview.register(UINib(nibName: "WishListViewCell", bundle: nil), forCellReuseIdentifier: "WishListViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 190
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return orders.count
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderViewCell", for: indexPath) as? OrderViewCell else {
                return UITableViewCell()
            }
            let order = orders[indexPath.row]
            cell.TotalPriceValue.text = order.totalPrice
            cell.CreationDateValue.text = order.creationDate
            cell.ShippedToValue.text = order.shippedTo
            cell.PhoneValue.text = order.phone
            return cell
        } else {
            print("WishListViewCell")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WishListViewCell", for: indexPath) as? WishListViewCell else {
                print("WishListViewCell")
                return UITableViewCell()
            }
            print("WishListViewCell")
            cell.productName.text = "Converse | Toddler Chuck Taylor All Star Axel Mid"
            cell.productPrice.text = "$70.00"
            cell.favImage.image = UIImage(named: "1")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Orders"
        } else {
            return "WishList"
        }
    }
}

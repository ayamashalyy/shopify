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
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        if section == 1 {
            return 60
        } else {
            return 5
        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let button = UIButton(type: .system)
        button.frame = CGRect(x: tableView.bounds.width - 100, y: 10, width: 80, height: 30)
        button.setTitle("See More", for: .normal)
        button.tag = section
        
        button.addTarget(self, action: #selector(headerButtonTapped(_:)), for: .touchUpInside)
        
        headerView.addSubview(button)
        
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: 200, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 25)
        if section == 0 {
            label.text = "Orders"
        } else {
            label.text = "WishList"
        }
        headerView.addSubview(label)
        
        return headerView
    }
    
    @objc func headerButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        if section == 0 {
            print("See More button in Orders section tapped")
            showMoreOrders()
        } else if section == 1 {
            print("See More button in WishList section tapped")
            showMoreWishListItems()
        }
    }
    
    func showMoreOrders() {
        print("See More button in Orders section tapped")
    }
    
    func showMoreWishListItems() {
        print("See More button in WishList section tapped")
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

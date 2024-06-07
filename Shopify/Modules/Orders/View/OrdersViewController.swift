//
//  OrdersViewController.swift
//  Shopify
//
//  Created by Rawan Elsayed on 06/06/2024.
//

import UIKit

class OrdersViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ordersTable: UITableView!
    
    var orders: [Order] = [
        Order(totalPrice: "$100", creationDate: "2023-05-01", shippedTo: "New York", phone: "123-456-7890"),
        Order(totalPrice: "$200", creationDate: "2023-06-01", shippedTo: "Los Angeles", phone: "098-765-4321"),
        Order(totalPrice: "$200", creationDate: "2023-06-01", shippedTo: "Los Angeles", phone: "098-765-4321") ,
        Order(totalPrice: "$200", creationDate: "2023-06-01", shippedTo: "Los Angeles", phone: "098-765-4321") ,
        Order(totalPrice: "$200", creationDate: "2023-06-01", shippedTo: "Los Angeles", phone: "098-765-4321")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTable.dataSource = self
        ordersTable.delegate = self
        ordersTable.register(UINib(nibName: "OrderViewCell", bundle: nil), forCellReuseIdentifier: "OrderViewCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
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
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderViewCell", for: indexPath) as? OrderViewCell else {
            return UITableViewCell()
        }
        let order = orders[indexPath.row]
        cell.TotalPriceValue.text = order.totalPrice
        cell.CreationDateValue.text = order.creationDate
        cell.ShippedToValue.text = order.shippedTo
        cell.PhoneValue.text = order.phone
        return cell
    }
    
    @IBAction func backToProfile(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}

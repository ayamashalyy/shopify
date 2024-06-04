//
//  PlaceOrderViewController.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//

import UIKit

class PlaceOrderViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var placeOrder: UIButton!
    
    var PlaceOrder = [
        ("Coupon", "No Coupon"),
        ("SubTotal", "1000 $"),
        ("Discount", "0,0 $"),
        ("Shipping Fees", "10 $"),
        ("GrandTotal", "250 $")
    ]
    
    @IBAction func placeOrder(_ sender: UIButton) {
        print("place order")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        setupButtons()
        tableview.register(UINib(nibName: "PlaceOrderCell", bundle: nil), forCellReuseIdentifier: "PlaceOrderCell")
    }
    
    
    func setupButtons() {
        placeOrder.backgroundColor = UIColor(hex: "#FF7D29")
        placeOrder.setTitleColor(UIColor.white, for: .normal)
        placeOrder.layer.cornerRadius = 10
        placeOrder.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceOrder.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceOrderCell", for: indexPath) as? PlaceOrderCell else {
            return UITableViewCell()
        }
        
        let order = PlaceOrder[indexPath.row]
        cell.titleLable.text = order.0
        cell.valueLable.text = order.1
        
        return cell
    }
    
    
    
}

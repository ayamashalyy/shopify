//
//  OrdersViewController.swift
//  Shopify
//
//  Created by Rawan Elsayed on 06/06/2024.
//

import UIKit

class OrdersViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ordersTable: UITableView!
    
    var orderViewModel = OrderViewModel.shared
    let settingsViewModel = SettingsViewModel()
    
    private let noOrdersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no_items.jpg")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTable.dataSource = self
        ordersTable.delegate = self
        ordersTable.register(UINib(nibName: "OrderViewCell", bundle: nil), forCellReuseIdentifier: "OrderViewCell")
        
        view.addSubview(noOrdersImageView)
        setupNoOrdersImageViewConstraints()
        
        fetchOrders()
        fetchExchangeRates()
        
    }
    
    private func setupNoOrdersImageViewConstraints() {
        NSLayoutConstraint.activate([
            noOrdersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noOrdersImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noOrdersImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            noOrdersImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }
    
    func fetchOrders() {
        orderViewModel.fetchOrders { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.ordersTable.reloadData()
                    
                    self.noOrdersImageView.isHidden = !self.orderViewModel.orders.isEmpty
                case .failure(let error):
                    print("Failed to fetch orders: \(error.localizedDescription)")
                    // Show an alert or handle error appropriately
                }
            }
        }
    }
    
    func fetchExchangeRates() {
        settingsViewModel.fetchExchangeRates { error in
            if let error = error {
                print("Failed to fetch exchange rates: \(error.localizedDescription)")
                return
            }
            // Fetch orders after exchange rates are fetched
            self.ordersTable.reloadData()
        }
    }
    
//    func confirmOrder(){
//        orderViewModel.createOrder { order, error in
//            if let order = order {
//                print("Order created successfully: \(order)")
//            } else if let error = error {
//                print("Failed to create order: \(error.localizedDescription)")
//            }
//        }
//    }
    
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
        return orderViewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderViewCell", for: indexPath) as? OrderViewCell else {
            return UITableViewCell()
        }
        let order = orderViewModel.orders[indexPath.row]
        
        // Convert price using SettingsViewModel
        let selectedCurrency = settingsViewModel.getSelectedCurrency() ?? .USD
        let convertedPriceString = settingsViewModel.convertPrice(order.total_price ?? "0", to: selectedCurrency) ?? "\(order.total_price)USD"
        
        cell.TotalPriceValue.text = convertedPriceString
        cell.CreationDateValue.text = order.created_at
        //cell.ShippedToValue.text = order.shipping_address?.address1
        //cell.PhoneValue.text = order.shipping_address?.phone
        //print(order.email)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orderViewModel.selectOrder(at: indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let orderDetailsVC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as? OrderDetailsViewController {
            orderDetailsVC.modalPresentationStyle = .fullScreen
            orderDetailsVC.orderViewModel = orderViewModel
            self.present(orderDetailsVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func backToProfile(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}

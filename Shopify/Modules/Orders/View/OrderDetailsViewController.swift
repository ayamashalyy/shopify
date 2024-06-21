//
//  OrderDetailsViewController.swift
//  Shopify
//
//  Created by Rawan Elsayed on 14/06/2024.
//

import UIKit

class OrderDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var shipedTo: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    
    let tableView = UITableView()
    var orderViewModel: OrderViewModel?
    let settingsViewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        fetchExchangeRates()
        updateUI()
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OrderItemCell.self, forCellReuseIdentifier: "OrderItemCell")
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: itemsLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateUI() {
        guard let order = orderViewModel?.selectedOrder else { return }
        
        // Convert price using SettingsViewModel
        let selectedCurrency = settingsViewModel.getSelectedCurrency() ?? .USD
        let convertedPriceString = settingsViewModel.convertPrice(order.total_price ?? "0", to: selectedCurrency) ?? "\(String(describing: order.total_price))USD"
                
        totalPrice.text = convertedPriceString
        creationDate.text = order.created_at
        shipedTo.text = "\(order.customer?.default_address?.address1 ?? "Alex"), \(order.customer?.default_address?.city ?? "Egypt")"
        phone.text = order.customer?.default_address?.phone
        tableView.reloadData()
    }
    
    func fetchExchangeRates() {
        settingsViewModel.fetchExchangeRates { error in
            if let error = error {
                print("Failed to fetch exchange rates: \(error.localizedDescription)")
                return
            }
            // Fetch orders after exchange rates are fetched
            self.tableView.reloadData()
            self.updateUI()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderViewModel?.selectedOrder?.line_items?.count ?? 00
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderItemCell
        if let item = orderViewModel?.selectedOrder?.line_items?[indexPath.row] {
            cell.titleLabel.text = item.title
            
            // Convert price using SettingsViewModel
            let selectedCurrency = settingsViewModel.getSelectedCurrency() ?? .USD
            let convertedPriceString = settingsViewModel.convertPrice(item.price ?? "0", to: selectedCurrency) ?? "\(item.price)USD"
            
            cell.priceLabel.text = "Price: \(convertedPriceString)"
            cell.quantityLabel.text = "Quantity: \(item.quantity ?? 0)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

import UIKit

class OrderItemCell: UITableViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#FF7D29").cgColor
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(quantityLabel)
        
        contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            quantityLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            quantityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            quantityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            quantityLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
}

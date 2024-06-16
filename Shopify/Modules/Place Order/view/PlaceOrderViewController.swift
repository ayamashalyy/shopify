//
//  PlaceOrderViewController.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//

import UIKit

class PlaceOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var placeOrder: UIButton!
    var summeryCartCollectionView: UICollectionView!
    let coponesImages = ["coupon2.jpg", "coupon2.jpg"]
    var viewModel = ShoppingCartViewModel()
    
    
    
    @IBAction func placeOrder(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let PaymentViewController = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController {
            PaymentViewController.modalPresentationStyle = .fullScreen
            present(PaymentViewController, animated: true, completion: nil)
        }
    }
    
    func setUpUI() {
        let cartLayout = UICollectionViewFlowLayout()
        cartLayout.scrollDirection = .horizontal
        summeryCartCollectionView = UICollectionView(frame: .zero, collectionViewLayout: cartLayout)
        view.addSubview(summeryCartCollectionView)
        summeryCartCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            summeryCartCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            summeryCartCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            summeryCartCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            summeryCartCollectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        summeryCartCollectionView.backgroundColor = UIColor.clear
        summeryCartCollectionView.dataSource = self
        summeryCartCollectionView.delegate = self
        
        summeryCartCollectionView.register(SummaryCartCell.self, forCellWithReuseIdentifier: "SummaryCartCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        setupButtons()
        tableview.register(UINib(nibName: "PlaceOrderCell", bundle: nil), forCellReuseIdentifier: "PlaceOrderCell")
        setUpUI()
        
        viewModel.updateCartItemsHandler = { [weak self] in
            self?.summeryCartCollectionView.reloadData()
        }
        
        viewModel.fetchDraftOrders { error in
            if let error = error {
                print("Failed to fetch draft orders: \(error)")
            }
        }
    }
    
    func setupButtons() {
        placeOrder.backgroundColor = UIColor(hex: "#FF7D29")
        placeOrder.setTitleColor(UIColor.white, for: .normal)
        placeOrder.layer.cornerRadius = 10
        placeOrder.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
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
        
        return cell
    }
    
    @IBAction func backToPSelectAddress(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension PlaceOrderViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCartCell", for: indexPath) as! SummaryCartCell
        let item = viewModel.cartItems[indexPath.item]
        cell.configureCell(imageUrl: item.3, title: item.0, price: "\(item.1)", quantity: item.2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 16, bottom: 30, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 200)
    }
}

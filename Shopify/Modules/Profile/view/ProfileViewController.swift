//
//  ProfileViewController.swift
//  Shopify
//
//  Created by aya on 05/06/2024.
//

import UIKit


class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var setting: UIBarButtonItem!
    var favViewModel: FavViewModel?
    var myfavLineItem: [FavLineItem] = []
    let indicator = UIActivityIndicatorView(style: .large)
    let settingsViewModel = SettingsViewModel()
    var orderViewModel = OrderViewModel()
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var tableview: UITableView!
    let shoppingCartViewModel = ShoppingCartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: "OrderViewCell", bundle: nil), forCellReuseIdentifier: "OrderViewCell")
        tableview.register(UINib(nibName: "WishListViewCell", bundle: nil), forCellReuseIdentifier: "WishListViewCell")
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        favViewModel = FavViewModel()
        setupCartButton()
        
        
    }
    
    func updateCartBadge() {
        let itemCount = shoppingCartViewModel.cartItemCount
        print("Item count: \(itemCount)")
        if itemCount > 0 {
            cartButton.addBadge(text: "\(itemCount)", color: .orange)
        } else {
            cartButton.removeBadge()
        }
    }
    
    
    private func fetchCartItemsAndUpdateBadge() {
        shoppingCartViewModel.fetchDraftOrders { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch cart items: \(error.localizedDescription)")
            } else {
                self.updateCartBadge()
            }
        }
    }
    
    func setupCartButton() {
        let button = UIButton(type: .custom)
        
        if let cartImage = UIImage(systemName: "cart.fill") {
            print("System cart image loaded successfully")
            let tintedImage = cartImage.withTintColor(.orange, renderingMode: .alwaysOriginal)
            let scaledImage = pondsize(image: tintedImage, size: CGSize(width: 30, height: 25))
            button.setImage(scaledImage, for: .normal)
        } else {
            print("Failed to load system cart image")
        }
        
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(navToShoppingCart(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 80)
        cartButton.customView = button
    }
    
    func pondsize(image: UIImage, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return scaledImage
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Authorize.isRegistedCustomer() {
            setting.isEnabled = true
            indicator.startAnimating()
            getWishList()
            getOrders()
            updateCartBadge()
            fetchCartItemsAndUpdateBadge()
        } else {
            setting.isEnabled = false
            self.showAlertWithTwoOption(message: "You are a guest,not have profile.Go to Login in?",
                                        okAction: { action in
                Navigation.ToALogin(from: self)
                print("OK button tapped")
            }
            )
        }
        
    }
    
    
    func getWishList(){
        myfavLineItem.removeAll()
        tableview.reloadData()
        
        var numberOfFav = 0
        print("get   WishListViewCell")
        favViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let lineItems = self.favViewModel?.LineItems else { return }
                
                for lineItem in lineItems {
                    if let productId = lineItem.product_id,
                       let imageUrl = lineItem.properties?.first(where: { $0.name == "imageUrl" })?.value,
                       let price = lineItem.price {
                        let favLineItem = FavLineItem(name: lineItem.title ?? "", productId: lineItem.product_id!, image: imageUrl, price: price, firstVariantid: lineItem.variant_id!)
                        if numberOfFav < 2
                        {
                            print("WishListViewCell\(numberOfFav)")
                            self.myfavLineItem.append(favLineItem)
                            numberOfFav += 1
                            
                        }
                        else
                        {
                            print("does not WishListViewCell")
                        }
                        
                        print("Fav: \(favLineItem)")
                    } else {
                        print("Error: Missing data in lineItem \(lineItem)")
                    }
                }
                self.indicator.stopAnimating()
                self.tableview.reloadData()
            }
        }
        favViewModel?.getFavs()
    }
    
    
    func getOrders() {
        orderViewModel.fetchOrders { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.tableview.reloadData()
                case .failure(let error):
                    print("Failed to fetch orders: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showAlertWithTwoOption(message: String, okAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: okAction)
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction)
        
        alertController.addAction(okAlertAction)
        alertController.addAction(cancelAlertAction)
        
        present(alertController, animated: true, completion: nil)
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
            return 80
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
            return orderViewModel.orders.count > 0 ? 1 : 0
        } else {
            return myfavLineItem.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderViewCell", for: indexPath) as? OrderViewCell else {
                return UITableViewCell()
            }
            if orderViewModel.orders.count > 0 {
                let order = orderViewModel.orders[0]
                cell.TotalPriceValue.text = order.current_subtotal_price
                cell.CreationDateValue.text = order.created_at
                cell.ShippedToValue.text = order.shipping_address?.address1
                cell.PhoneValue.text = order.shipping_address?.phone
                print(order.email)
            }
            return cell
        } else {
            print("WishListViewCell")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WishListViewCell", for: indexPath) as? WishListViewCell else {
                print("WishListViewCell")
                return UITableViewCell()
            }
            print("WishListViewCell")
            if myfavLineItem.count > 0 {
                let favItem = myfavLineItem[indexPath.row]
                cell.productName.text = favItem.name
                let selectedCurrency = settingsViewModel.getSelectedCurrency() ?? .USD
                let convertedPriceString = settingsViewModel.convertPrice(favItem.price, to: selectedCurrency) ?? "\(favItem.price)$"
                cell.productPrice.text = convertedPriceString
                cell.favImage.kf.setImage(with: URL(string: favItem.image))
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return "WishList"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let headerView = UIView()
        let button = UIButton(type: .system)
        button.frame = CGRect(x: tableView.bounds.width - 100, y: 10, width: 80, height: 30)
        button.setTitle("See More", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tag = section
        button.addTarget(self, action: #selector(headerButtonTapped(_:)), for: .touchUpInside)
        headerView.addSubview(button)
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: 200, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 25)
        if section == 1 {
            label.text = "WishList"
        }
        headerView.addSubview(label)
        
        return headerView
    }
    
    @objc func headerButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        if section == 1 {
            print("See More button in WishList section tapped")
            showMoreWishListItems()
        }
    }
    
    func showMoreWishListItems() {
        Navigation.ToAllFavourite(from: self)
    }
    
    @IBAction func seeMoreOrders(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let OrdersViewController = storyboard.instantiateViewController(withIdentifier: "OrdersViewController") as? OrdersViewController {
            OrdersViewController.modalPresentationStyle = .fullScreen
            present(OrdersViewController, animated: true, completion: nil)
        } else {
            print("Failed to instantiate OrdersViewController")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 50
    }
    
    @IBAction func navToSettings(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            settingsViewController.modalPresentationStyle = .fullScreen
            present(settingsViewController, animated: true, completion: nil)
        } else {
            print("Failed to instantiate SettingsViewController")
        }
    }
    
    
    @IBAction func navToShoppingCart(_ sender: UIBarButtonItem) {
        Navigation.ToOrders(from: self)
    }
}




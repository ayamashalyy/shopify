import UIKit
import Kingfisher

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var getThemButton: UIButton!
    
    let shoppingCartViewModel = ShoppingCartViewModel()
    var productViewModel = ProductViewModel()
    let settingsViewModel = SettingsViewModel()
    
    var cartItems = [(String, Int, Int,String?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupButtons()
        updateSubtotal()
        tableView.register(UINib(nibName: "ShoppingCartableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingCartableViewCell")
        fetchDraftOrders()
        fetchExchangeRates()
        
        productViewModel.bindResultToViewController = { [weak self] in
            //print("shopping cart in  productViewModel.bindResultToViewController ")
            DispatchQueue.main.async {
                guard let self = self, let product = self.productViewModel.product else { return }
                self.updateCartItemWithImage(for: product)
            }
        }
    }
    
    func fetchDraftOrders() {
        shoppingCartViewModel.fetchDraftOrders { [weak self] (draftOrders, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching draft orders: \(error.localizedDescription)")
            } else if let draftOrders = draftOrders {
                print("Fetched draft orders: \(draftOrders)")
                self.updateCartItems(with: draftOrders)
            }
        }
    }
    
    func fetchExchangeRates(){
        settingsViewModel.fetchExchangeRates { [weak self] error in
            if let error = error {
                print("Error fetching exchange rates: \(error)")
            } else {
                // Reload data once exchange rates are fetched
                self?.tableView.reloadData()
            }
        }
    }
    
    func updateCartItems(with draftOrders: DraftOrder) {
            guard let lineItems = draftOrders.line_items else {
                return
            }
            
            for lineItem in lineItems {
                let title = lineItem.title ?? "Unknown"
                let quantity = lineItem.quantity ?? 0
                let price = lineItem.price ?? "0.00"
                let priceFloat = Float(price) ?? 0.0
                let priceInt = Int(priceFloat)
             //   print("shopping cart is ................................\(lineItem.product_id!)")
                productViewModel.getProductDetails(id: "\(lineItem.product_id!)")
                
                if let index = cartItems.firstIndex(where: { $0.0 == title }) {
                    cartItems[index].2 += quantity
                } else {
                    cartItems.append((title, priceInt, quantity, nil))
                }
            }
        
        
        
      //  print("Updated cart items: \(cartItems)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateSubtotal()
        }
    }
    
    func updateCartItemWithImage(for product: Product) {
           if let index = cartItems.firstIndex(where: { $0.0 == product.name }) {
               if let imageUrl = product.images.first?.url {
                   cartItems[index].3 = imageUrl
                   DispatchQueue.main.async {
                       self.tableView.reloadData()
                   }
               }
           }
       }
    
    func setupButtons() {
        getThemButton.backgroundColor = UIColor(hex: "#FF7D29")
        getThemButton.setTitleColor(UIColor.white, for: .normal)
        getThemButton.layer.cornerRadius = 10
        getThemButton.clipsToBounds = true
    }
    
    func customizeButton(button: UIButton) {
        button.backgroundColor = UIColor(hex: "#FF7D29")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartableViewCell", for: indexPath) as? ShoppingCartableViewCell else {
            fatalError("The dequeued cell is not an instance of ShoppingCartableViewCell.")
        }
        let item = cartItems[indexPath.row]
        cell.productNameLabel.text = "\(item.0)"
        //cell.productPriceLabel.text = "\(item.1)$"
        
        // Convert price using SettingsViewModel
        let selectedCurrency = settingsViewModel.getSelectedCurrency() ?? .USD
        let convertedPriceString = settingsViewModel.convertPrice(String(item.1), to: selectedCurrency) ?? "\(item.1)$"
        cell.productPriceLabel.text = convertedPriceString
        
        cell.quantityLabel.text = "\(item.2)"
        if let imageUrl = item.3 {
            cell.productImageView.kf.setImage(with: URL(string: imageUrl))
        } else {
            cell.productImageView.image = nil
        }
        cell.incrementButton.tag = indexPath.row
        cell.decrementButton.tag = indexPath.row
        cell.incrementButton.addTarget(self, action: #selector(incrementQuantity(_:)), for: .touchUpInside)
        cell.decrementButton.addTarget(self, action: #selector(decrementQuantity(_:)), for: .touchUpInside)
        customizeButton(button: cell.incrementButton)
        customizeButton(button: cell.decrementButton)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    @objc func incrementQuantity(_ sender: UIButton) {
        let row = sender.tag
        cartItems[row].2 += 1
        tableView.reloadData()
        updateSubtotal()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    @objc func decrementQuantity(_ sender: UIButton) {
        let row = sender.tag
        if cartItems[row].2 > 0 {
            cartItems[row].2 -= 1
            tableView.reloadData()
            updateSubtotal()
        }
    }
    
    func updateSubtotal() {
        let subtotal = cartItems.reduce(0) { $0 + $1.1 * $1.2 }
        //subtotalLabel.text = "\(subtotal)$"
        
        // Convert subtotal using SettingsViewModel
        let selectedCurrency = settingsViewModel.getSelectedCurrency() ?? .USD
        let convertedSubtotalString = settingsViewModel.convertPrice(String(subtotal), to: selectedCurrency) ?? "\(subtotal)$"
        
        subtotalLabel.text = convertedSubtotalString
    }
    
    @IBAction func getThemButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let selectAddressVC = storyboard.instantiateViewController(withIdentifier: "SelectAddressViewController") as? SelectAddressViewController {
            selectAddressVC.modalPresentationStyle = .fullScreen
            present(selectAddressVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func backToProfile(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

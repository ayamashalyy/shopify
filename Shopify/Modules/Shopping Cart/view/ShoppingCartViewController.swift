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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDraftOrders()
        shoppingCartViewModel.updateCartItemsHandler = { [weak self] in
            self?.tableView.reloadData()
            self?.updateSubtotal()
        }
        fetchExchangeRates()
        if Authorize.isRegistedCustomer() {
            getThemButton.isEnabled = true
            
        }else{
            getThemButton.isEnabled = false
            self.showAlertWithTwoOption(message: "Login to add to cart?",
                                        okAction: { action in
                Navigation.ToALogin(from: self)
                print("OK button tapped")
            }
            )
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
    
    func fetchDraftOrders() {
        shoppingCartViewModel.fetchDraftOrders { [weak self] error in
            if let error = error {
                print("Error fetching draft orders: \(error.localizedDescription)")
            } else {
                self?.tableView.reloadData()
                self?.updateSubtotal()
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
        return shoppingCartViewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartableViewCell", for: indexPath) as? ShoppingCartableViewCell else {
            fatalError("The dequeued cell is not an instance of ShoppingCartableViewCell.")
        }
        let item = shoppingCartViewModel.cartItems[indexPath.row]
        cell.productNameLabel.text = "\(item.0)"
        
        // Convert price using SettingsViewModel
        let selectedCurrency = settingsViewModel.getSelectedCurrency() ?? .USD
        let convertedPriceString = settingsViewModel.convertPrice(String(item.1), to: selectedCurrency) ?? "\(item.1)USD"
        cell.productPriceLabel.text = convertedPriceString
        
        cell.quantityLabel.text = "\(item.2)"
        cell.sizeLable.text = "\(item.6)"
        
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
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var productId = shoppingCartViewModel.cartItems[indexPath.row].7
        let storyboard = UIStoryboard(name: "third", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "productDetails") as? ProductViewController {
            vc.productId = String(productId)
            vc.selectedVarientId = shoppingCartViewModel.cartItems[indexPath.row].4
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    @objc func incrementQuantity(_ sender: UIButton) {
        let row = sender.tag
        let item = shoppingCartViewModel.cartItems[row]
        let newQuantity = item.2 + 1
        print("newQuantity\(newQuantity)")
        let maxQuantity = item.5 / 2
        print("maxQuantity\(maxQuantity)")
        
        if newQuantity > maxQuantity {
            showAlert(message: "You cannot order more than half of the available quantity.")
        } else {
            shoppingCartViewModel.updateItemQuantity(itemId: item.4, newQuantity: newQuantity) { error in
                print("shoppingCartViewModel.updateItemQuantity(itemId: item.4, newQuantity: newQuantity)\(newQuantity)")
                if let error = error {
                    print("Error updating item quantity: \(error.localizedDescription)")
                } else {
                    self.updateSubtotal()
                }
            }
        }
    }
    
    @objc func decrementQuantity(_ sender: UIButton) {
        let row = sender.tag
        let item = shoppingCartViewModel.cartItems[row]
        let newQuantity = max(0, item.2 - 1)
        
        if newQuantity == 0 {
            let alert = UIAlertController(title: "Delete Item", message: "Do you want to remove this item from your cart?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.shoppingCartViewModel.deleteLineItem(with: self?.shoppingCartViewModel.cartItems ?? [], variantId: item.4, newQuantity: newQuantity) { error in
                    if let error = error {
                        print("Error deleting item: \(error.localizedDescription)")
                    } else {
                        self?.shoppingCartViewModel.cartItems.remove(at: row)
                        self?.tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                        self?.updateSubtotal()
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            shoppingCartViewModel.updateItemQuantity(itemId: item.4, newQuantity: newQuantity) { error in
                if let error = error {
                    print("Error updating item quantity: \(error.localizedDescription)")
                } else {
                    self.updateSubtotal()
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = shoppingCartViewModel.cartItems[indexPath.row]
            let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item from your cart?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.shoppingCartViewModel.deleteLineItem(with: self?.shoppingCartViewModel.cartItems ?? [], variantId: item.4, newQuantity: item.2) { error in
                    if let error = error {
                        print("Error deleting item: \(error.localizedDescription)")
                    } else {
                        self?.shoppingCartViewModel.cartItems.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        self?.updateSubtotal()
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func updateSubtotal() {
        
        let subtotal = shoppingCartViewModel.cartItems.reduce(0) { $0 + $1.1 * $1.2 }
        subtotalLabel.text = "\(subtotal)$"
        
        
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


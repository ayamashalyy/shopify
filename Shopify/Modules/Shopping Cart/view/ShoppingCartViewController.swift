import UIKit
import Kingfisher

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var getThemButton: UIButton!
    
    let shoppingCartViewModel = ShoppingCartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupButtons()
        updateSubtotal()
        tableView.register(UINib(nibName: "ShoppingCartableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingCartableViewCell")
        fetchDraftOrders()
        
        shoppingCartViewModel.updateCartItemsHandler = { [weak self] in
            self?.tableView.reloadData()
            self?.updateSubtotal()
        }
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
        cell.productPriceLabel.text = "\(item.1)$"
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
        shoppingCartViewModel.cartItems[row].2 += 1
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
        if shoppingCartViewModel.cartItems[row].2 > 0 {
            shoppingCartViewModel.cartItems[row].2 -= 1
            tableView.reloadData()
            updateSubtotal()
        }
    }
    
    func updateSubtotal() {
        let subtotal = shoppingCartViewModel.cartItems.reduce(0) { $0 + $1.1 * $1.2 }
        subtotalLabel.text = "\(subtotal)$"
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

//
//  AllFavViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

struct FavLineItem {
    let name: String
    let productId: Int
    let image: String
    let price: String
    let firstVariantid: Int
}

class AllFavViewController: UIViewController {
    
    var favViewModel: FavViewModel?
    let indicator = UIActivityIndicatorView(style: .large)
    var myfavLineItem: [FavLineItem] = []
    let settingsViewModel = SettingsViewModel()
    var productViewModel = ProductViewModel()
    
    @IBOutlet weak var allFavTable: UITableView!
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allFavTable.dataSource = self
        allFavTable.delegate = self
        fetchExchangeRates()
        allFavTable.register(UINib(nibName: "WishListViewCell", bundle: nil), forCellReuseIdentifier: "WishListViewCell")
        allFavTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        favViewModel = FavViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Authorize.isRegistedCustomer() {
            setUpUI()
            
            myfavLineItem.removeAll()
            allFavTable.reloadData()
            
            favViewModel?.bindResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self, let lineItems = self.favViewModel?.LineItems else { return }
                    
                    for lineItem in lineItems {
                        if let productId = lineItem.product_id,
                           let imageUrl = lineItem.properties?.first(where: { $0.name == "imageUrl" })?.value,
                           let price = lineItem.price {
                            let favLineItem = FavLineItem(name: lineItem.title ?? "", productId: lineItem.product_id!, image: imageUrl, price: price, firstVariantid: lineItem.variant_id!)
                            self.myfavLineItem.append(favLineItem)
                            print("Fav: \(favLineItem)")
                        } else {
                            print("Error: Missing data in lineItem \(lineItem)")
                        }
                    }
                    self.indicator.stopAnimating()
                    self.checkIfNoData()
                    self.allFavTable.reloadData()
                }
            }
            favViewModel?.getFavs()
        }else{
            self.showAlertWithTwoOption(message: "Login to add to faviourts?",
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
    
    func checkIfNoData() {
        if myfavLineItem.count <= 1 {
            allFavTable.backgroundView = createNoDataBackgroundView()
        } else {
            allFavTable.backgroundView = nil
        }
    }
    
    func fetchExchangeRates() {
        settingsViewModel.fetchExchangeRates { [weak self] error in
            if let error = error {
                print("Error fetching exchange rates: \(error)")
            } else {
                self?.allFavTable.reloadData()
            }
        }
    }
    
    func setUpUI() {
        indicator.center = self.view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    func createNoDataBackgroundView() -> UIView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let label = UILabel()
        label.text = "No Favorites yet. Add to it"
        label.textColor = .orange
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        return containerView
    }
}

extension AllFavViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = max(myfavLineItem.count - 1, 0)
        checkIfNoData()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListViewCell", for: indexPath) as! WishListViewCell
        guard myfavLineItem.count > indexPath.row else {
            return cell
        }
        let favItem = myfavLineItem[indexPath.row]
        cell.productName.text = favItem.name
        
        let selectedCurrency = settingsViewModel.getSelectedCurrency() ?? .USD
        let convertedPriceString = settingsViewModel.convertPrice(favItem.price, to: selectedCurrency) ?? "\(favItem.price)$"
        cell.productPrice.text = convertedPriceString
        
        cell.favImage.kf.setImage(with: URL(string: favItem.image))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productId = myfavLineItem[indexPath.row].productId
        
        let storyboard = UIStoryboard(name: "third", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "productDetails") as! ProductViewController
        vc.productId = String(productId)
        vc.isComeFromFaviourts = true
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let firstVariantId = myfavLineItem[indexPath.row].firstVariantid
        if editingStyle == .delete {
            
            self.indicator.startAnimating()
            
            favViewModel?.removeLineItem(index: indexPath.row)
            
            let alertController = UIAlertController(title: "Confirmation", message: "Are you sure? Remove from favorites?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.productViewModel.removeFromFavDraftOrders(VariantsId: firstVariantId) { isSuccess in
                    DispatchQueue.main.async {
                        if isSuccess {
                            print("Removed from favorites table")
                            self.myfavLineItem.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            self.checkIfNoData()
                            self.indicator.stopAnimating()
                            
                        }
                    }
                }
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
}

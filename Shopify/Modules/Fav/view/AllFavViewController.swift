//
//  AllFavViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit


struct FavLineItem {
    let name: String
    let productId : Int
    let image : String
    let price : String
}

class AllFavViewController: UIViewController {
    
    var favViewModel : FavViewModel?
    let indicator = UIActivityIndicatorView(style: .large)
    var myfavLineItem : [FavLineItem] = []
    let settingsViewModel = SettingsViewModel()

    
    @IBOutlet weak var allFavTable: UITableView!
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allFavTable.dataSource = self
        allFavTable.delegate = self
        
        allFavTable.register(UINib(nibName: "WishListViewCell", bundle: nil), forCellReuseIdentifier: "WishListViewCell")
        allFavTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        favViewModel = FavViewModel()
        checkIfNoData()
        setUpUI()
      //  fetchExchangeRates()
        
        favViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let lineItems = self.favViewModel?.LineItems else { return }
                
                for lineItem in lineItems {
                    if let productId = lineItem.product_id,
                       let imageUrl = lineItem.properties?.first(where: { $0.name == "imageUrl" })?.value,
                       let price = lineItem.price {
                        let favLineItem = FavLineItem(name: lineItem.title ?? "", productId: lineItem.product_id!, image: imageUrl, price: price)
                        self.myfavLineItem.append(favLineItem)
                        print("Fav: \(favLineItem)")
                    } else {
                        print("Error: Missing data in lineItem \(lineItem)")
                    }
                }
                self.allFavTable.reloadData()
                self.indicator.stopAnimating()
            }
        }

        favViewModel?.getFavs()
    }
    
    
    func checkIfNoData() {
        if myfavLineItem.isEmpty {
            allFavTable.backgroundView = createNoDataBackgroundView()
        } else {
            allFavTable.backgroundView = nil
        }
    }
    
    func fetchExchangeRates(){
        settingsViewModel.fetchExchangeRates { [weak self] error in
            if let error = error {
                print("Error fetching exchange rates: \(error)")
            } else {
                // Reload data once exchange rates are fetched
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
            let count = myfavLineItem.count - 1
            if count <= 0 {
                tableView.backgroundView = createNoDataBackgroundView()
            } else {
                tableView.backgroundView = nil
            }
            return max(count, 0)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WishListViewCell", for: indexPath) as! WishListViewCell
               guard myfavLineItem.count > indexPath.row + 1 else {
                   return cell
               }
               let favItem = myfavLineItem[indexPath.row + 1]
               cell.productName.text = favItem.name
            
                // Convert price using SettingsViewModel
               let selectedCurrency = settingsViewModel.getSelectedCurrency() ?? .USD
               let convertedPriceString = settingsViewModel.convertPrice(favItem.price, to: selectedCurrency) ?? "\(favItem.price)$"
               cell.productPrice.text = convertedPriceString
            
               //cell.productPrice.text = favItem.price
               cell.favImage.kf.setImage(with: URL(string: favItem.image))
               return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let productId = myfavLineItem[indexPath.row + 1].productId
            
            let storyboard = UIStoryboard(name: "third", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "productDetails") as! ProductViewController
                vc.productId =  String(productId)
                vc.isComeFromFaviourts = true
                vc.modalPresentationStyle = .fullScreen

                present(vc, animated: true, completion: nil)
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 60
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                favViewModel?.removeLineItem(index: (indexPath.row + 1))// increase by 1 as we do not show first item
                myfavLineItem.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                checkIfNoData()
            }
        }
    }

        


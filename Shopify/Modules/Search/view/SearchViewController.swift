//
//  SearchViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CustomCategoriesCellDelegate {
    
    var settingsViewModel  = SettingsViewModel()
    var comeFromHome: Bool?
    
    var isSearching = false
    var isFiltering = false
    
    var searchViewModel: SearchViewModel!
    
    var searchCollectionView: UICollectionView!

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var priceFilter: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setUpUi()
        
        if comeFromHome ?? false {
            searchViewModel.bindResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    self?.searchViewModel.filteredProducts = self?.searchViewModel.recevingProductFromANotherScreen ?? []
                    self?.searchCollectionView.reloadData()
                }
            }
            searchViewModel.getProducts()
        }
        
        priceFilter.isHidden = true
        priceFilter.text = "10.0"
        slider.isHidden = true
    }
    
    @IBAction func filter(_ sender: Any) {
        slider.isHidden.toggle()
        priceFilter.isHidden.toggle()
        
        if slider.isHidden {
            searchViewModel.filteredProducts = searchViewModel.recevingProductFromANotherScreen ?? []
            isFiltering = false
        } else {
            filterProductsByCurrentSliderValue()
            isFiltering = true
        }
        
        searchCollectionView.reloadData()
    }
    
    @IBAction func slider(_ sender: UISlider) {
        let currentValue = String(format: "%.2f", sender.value)
        priceFilter.text = "\(currentValue)"
        filterProductsByCurrentSliderValue()
    }
    
    func filterProductsByCurrentSliderValue() {
        if let currentValue = Float(priceFilter.text ?? "10.0") {
            searchViewModel.filteredProducts = searchViewModel.filterProducts(filteredProducts: searchViewModel.recevingProductFromANotherScreen ?? [], byPrice: currentValue)
            searchCollectionView.reloadData()
        }
    }
    
    func setUpUi() {
        let layout = UICollectionViewFlowLayout()
        searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(searchCollectionView)
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchCollectionView.topAnchor.constraint(equalTo: priceFilter.bottomAnchor, constant: 10).isActive = true
        searchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        searchCollectionView.backgroundColor = UIColor.clear
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.register(CustomCategoriesCell.self, forCellWithReuseIdentifier: "CustomCategoriesCell")
        slider.minimumValue = 10.0
        slider.maximumValue = 500.0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            searchViewModel.filteredProducts = searchViewModel.recevingProductFromANotherScreen
        } else {
            isSearching = true
            searchViewModel.filteredProducts = searchViewModel.recevingProductFromANotherScreen.filter { product in
                product.name.lowercased().contains(searchText.lowercased())
            }
        }
        searchCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        searchViewModel.filteredProducts = searchViewModel.recevingProductFromANotherScreen
        searchCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching || isFiltering ? searchViewModel.filteredProducts.count : searchViewModel.recevingProductFromANotherScreen.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCategoriesCell", for: indexPath) as! CustomCategoriesCell
        let product = isSearching || isFiltering ? searchViewModel.filteredProducts[indexPath.row] : searchViewModel.recevingProductFromANotherScreen[indexPath.row]
        
        cell.nameCategoriesLabel.text = product.name
        
        if let selectedCurrency = settingsViewModel.getSelectedCurrency(),
           let convertedPrice = settingsViewModel.convertPrice(product.variants.first?.price ?? "N/A", to: selectedCurrency) {
            cell.priceLabel.text = convertedPrice
        } else {
            cell.priceLabel.text = product.variants.first?.price
        }
        
        if let imageUrlString = product.images.first?.url, let imageUrl = URL(string: imageUrlString) {
            cell.categoriesImgView.kf.setImage(with: imageUrl)
        } else {
            cell.categoriesImgView.image = UIImage(named: "splash-img.jpg")
        }
        
        if product.variants[0].isSelected {
            cell.heartButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        } else {
            cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        cell.heartButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func didTapHeartButton(in cell: CustomCategoriesCell) {
        var productViewModel = ProductViewModel()
        if let indexPath = searchCollectionView.indexPath(for: cell) {
            let product = isSearching || isFiltering ? searchViewModel.filteredProducts[indexPath.row] : searchViewModel.recevingProductFromANotherScreen[indexPath.row]
            
            if Authorize.isRegistedCustomer() {
                cell.heartButton.isEnabled = false
                
                if product.variants[0].id != fakeProductInDraftOrder {
                    if product.variants[0].isSelected {
                        showAlertWithTwoOption(message: "Are you sure you want to remove from favorites?",
                                               okAction: { [weak self] _ in
                            productViewModel.removeFromFavDraftOrders(VariantsId: product.variants[0].id) { isSuccess in
                                DispatchQueue.main.async {
                                    if isSuccess {
                                        product.variants[0].isSelected = false
                                        cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
                                        cell.heartButton.isEnabled = true
                                    } else {
                                        self?.showAlertWithTwoOption(message: "Failed to remove from favorites")
                                        cell.heartButton.isEnabled = true
                                    }
                                }
                            }
                        }, cancelAction: { _ in
                            cell.heartButton.isEnabled = true
                        })
                    } else {
                        productViewModel.addToFavDraftOrders(selectedVariantsData: [(product.variants[0].id, product.images.first?.url ?? "", 1)]) { [weak self] isSuccess in
                            DispatchQueue.main.async {
                                if isSuccess {
                                    cell.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                    cell.heartButton.isEnabled = true
                                    product.variants[0].isSelected = true
                                    self?.showCheckMarkAnimation(mark: "heart.fill")
                                } else {
                                    self?.showAlertWithTwoOption(message: "Failed to add to favorites")
                                    cell.heartButton.isEnabled = true
                                }
                            }
                        }
                    }
                } else {
                    showAlert(message: "Sorry, failed to handle favourite status of this product...check other products.")
                }
            } else {
                showAlertWithTwoOptionOkayAndCancel(message: "Login to add to favorites?",
                                                    okAction: { _ in
                    Navigation.ToALogin(from: self)
                    print("Login OK button tapped")
                })
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 20, height: 260)
    }
    
    
    private func showAlertWithTwoOptionOkayAndCancel(message: String, okAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Okay", style: .default, handler: okAction)
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction)
        alertController.addAction(okAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    private func showAlert(message: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertWithTwoOption(message: String, okAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: okAction)
        alertController.addAction(okAlertAction)
        
        if let cancelAction = cancelAction {
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction)
            alertController.addAction(cancelAlertAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
}

/*
class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CustomCategoriesCellDelegate {
    
    var settingsViewModel  = SettingsViewModel()
    
    var comeFromHome: Bool? = true
    
    
    var isSearching = false
    var isFiltering = false
    
    var searchViewModel : SearchViewModel!
    
    var searchCollectionView: UICollectionView!

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var priceFilter: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func back(_ sender: Any) {
            dismiss(animated: true)
        }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setUpUi()
        loadProducts()
        
        priceFilter.isHidden = true
        priceFilter.text = "10.0"
        
        slider.isHidden = true
    }
    func loadProducts() {
        if comeFromHome ?? false {
            searchViewModel.bindResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    self?.searchViewModel.recevingProductFromANotherScreen = self?.searchViewModel.recevingProductFromANotherScreen ?? []
                    self?.searchViewModel.filteredProducts = self?.searchViewModel.recevingProductFromANotherScreen ?? []
                    self?.searchCollectionView.reloadData()
                }
            }
            searchViewModel.getProducts()
        }
        searchCollectionView.reloadData()
    }
    
    
    @IBAction func filter(_ sender: Any) {
        slider.isHidden.toggle()
        priceFilter.isHidden.toggle()
        
        if slider.isHidden {
            // the oriiiignal
            searchViewModel.filteredProducts = searchViewModel.recevingProductFromANotherScreen ?? []
            isFiltering = false
        } else {
            filterProductsByCurrentSliderValue()
            isFiltering = true
        }
        
        searchCollectionView.reloadData()
    }
    
    @IBAction func slider(_ sender: UISlider) {
        let currentValue = String(format: "%.2f", sender.value)
        priceFilter.text = "\(currentValue)"
        filterProductsByCurrentSliderValue()
    }
    
    func filterProductsByCurrentSliderValue() {
        if let currentValue = Float(priceFilter.text ?? "10.0") {
            searchViewModel.filteredProducts = searchViewModel.filterProducts(filteredProducts: searchViewModel.recevingProductFromANotherScreen ?? [], byPrice: currentValue)
            searchCollectionView.reloadData()
        }
    }
    
    func setUpUi() {
        let layout = UICollectionViewFlowLayout()
        searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(searchCollectionView)
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchCollectionView.topAnchor.constraint(equalTo: priceFilter.bottomAnchor, constant: 10).isActive = true
        searchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        searchCollectionView.backgroundColor = UIColor.clear
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.register(CustomCategoriesCell.self, forCellWithReuseIdentifier: "CustomCategoriesCell")
        slider.minimumValue = 10.0
        slider.maximumValue = 500.0
    }
    
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            searchViewModel.filteredProducts = searchViewModel.recevingProductFromANotherScreen!
        } else {
            isSearching = true
            searchViewModel.filteredProducts = searchViewModel.recevingProductFromANotherScreen!.filter { product in
                product.name.lowercased().contains(searchText.lowercased())
            }
        }
        searchCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        searchViewModel.filteredProducts = searchViewModel.recevingProductFromANotherScreen!
        searchCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching || isFiltering ? searchViewModel.filteredProducts.count : searchViewModel.recevingProductFromANotherScreen!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCategoriesCell", for: indexPath) as! CustomCategoriesCell
        let product = isSearching || isFiltering ? searchViewModel.filteredProducts[indexPath.row] : searchViewModel.recevingProductFromANotherScreen![indexPath.row]
        
        cell.nameCategoriesLabel.text = product.name
        
        if let selectedCurrency = settingsViewModel.getSelectedCurrency(),
           let convertedPrice = settingsViewModel.convertPrice(product.variants.first?.price ?? "N/A", to: selectedCurrency) {
            cell.priceLabel.text = convertedPrice
        } else {
            cell.priceLabel.text = product.variants.first?.price
        }
        
        if let imageUrlString = product.images.first?.url, let imageUrl = URL(string: imageUrlString) {
            cell.categoriesImgView.kf.setImage(with: imageUrl)
        } else {
            cell.categoriesImgView.image = UIImage(named: "splash-img.jpg")
        }
        
        if product.variants[0].isSelected {
            cell.heartButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        } else {
            cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        cell.heartButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func didTapHeartButton(in cell: CustomCategoriesCell) {
        var productViewModel = ProductViewModel()
        if let indexPath = searchCollectionView.indexPath(for: cell) {
            let product = isSearching || isFiltering ? searchViewModel.filteredProducts[indexPath.row] : searchViewModel.recevingProductFromANotherScreen![indexPath.row]
            
            if Authorize.isRegistedCustomer() {
                cell.heartButton.isEnabled = false
                
                if product.variants[0].id != fakeProductInDraftOrder {
                    if product.variants[0].isSelected {
                        // Remove from fav
                        showAlertWithTwoOption(message: "Are you sure you want to remove from favorites?",
                                               okAction: { [weak self] _ in
                            productViewModel.removeFromFavDraftOrders(VariantsId: product.variants[0].id) { isSuccess in
                                DispatchQueue.main.async {
                                    if isSuccess {
                                        product.variants[0].isSelected = false
                                        cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
                                        cell.heartButton.isEnabled = true
                                    } else {
                                        self?.showAlertWithTwoOption(message: "Failed to remove from favorites")
                                        cell.heartButton.isEnabled = true
                                    }
                                }
                            }
                        }, cancelAction: { _ in
                            cell.heartButton.isEnabled = true
                        })
                    } else {
                        // Add to fav
                        productViewModel.addToFavDraftOrders(selectedVariantsData: [(product.variants[0].id, product.images.first?.url ?? "", 1)]) { [weak self] isSuccess in
                            DispatchQueue.main.async {
                                if isSuccess {
                                    cell.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                    cell.heartButton.isEnabled = true
                                    product.variants[0].isSelected = true
                                    self?.showCheckMarkAnimation(mark: "heart.fill")
                                } else {
                                    self?.showAlertWithTwoOption(message: "Failed to add to favorites")
                                    cell.heartButton.isEnabled = true
                                }
                            }
                        }
                    }
                } else {
                    showAlert(message: "Sorry, failed to handle favourite status of this product...check other products.")
                }
            } else {
                showAlertWithTwoOptionOkayAndCancel(message: "Login to add to favorites?",
                                                    okAction: { _ in
                    Navigation.ToALogin(from: self)
                    print("Login OK button tapped")
                })
            }
        }
    }
    
    private func showAlert(message: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertWithTwoOption(message: String, okAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: okAction)
        alertController.addAction(okAlertAction)
        
        if let cancelAction = cancelAction {
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction)
            alertController.addAction(cancelAlertAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertWithTwoOptionOkayAndCancel(message: String, okAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Okay", style: .default, handler: okAction)
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction)
        alertController.addAction(okAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 20, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = isSearching || isFiltering ? searchViewModel.filteredProducts[indexPath.row] : searchViewModel.recevingProductFromANotherScreen![indexPath.row]
        Navigation.ToProduct(productId: "\(product.id)", from: self)
    }
}
*/

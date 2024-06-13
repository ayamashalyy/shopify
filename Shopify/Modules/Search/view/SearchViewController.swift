//
//  SearchViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    var comeFromHome : Bool? = true // true for testing only the left it was out value
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var isSearching = false
    
    var searchViewModel = SearchViewModel()
    var searchCollectionView: UICollectionView!

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
      
        setUpUi()
        loadProducts()
    }
    
    func setUpUi(){
        
        let layout = UICollectionViewFlowLayout()
        searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(searchCollectionView)
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        searchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        searchCollectionView.backgroundColor = UIColor.clear
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.register(CustomCategoriesCell.self, forCellWithReuseIdentifier: "CustomCategoriesCell")
               
    }
    
    func loadProducts() {
        if comeFromHome ?? false {

                print("inside")
            searchViewModel.bindResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    self?.products = self?.searchViewModel.products ?? []
                  //  self?.filteredProducts = self?.searchViewModel.products ?? []
                    self?.searchCollectionView.reloadData()
                }
            }
            searchViewModel.getProducts()
            
        }
        else {
            
            filteredProducts = products
        }
        
        searchCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredProducts = products
        } else {
            isSearching = true
             filteredProducts = products.filter { product in
                product.name.lowercased().contains(searchText.lowercased())
            }
            print("fitered = \(filteredProducts)")

        }
        searchCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        filteredProducts = products
        searchCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredProducts.count : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var settingsViewModel = SettingsViewModel()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCategoriesCell", for: indexPath) as! CustomCategoriesCell
        
         let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
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
        cell.heartButton.tintColor = UIColor.white
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 1 - 35 , height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
        Navigation.ToProduct(productId: "\(product.id)", from: self)
    }

}

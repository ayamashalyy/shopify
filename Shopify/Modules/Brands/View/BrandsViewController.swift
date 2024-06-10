//
//  BrandsViewController.swift
//  Shopify
//
//  Created by Rawan Elsayed on 04/06/2024.
//

import UIKit

class BrandsViewController: UIViewController {
    
    @IBOutlet weak var sliderFilter: UISlider!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var brandProductsViewModel = BrandProductsViewModel()
    
    var categoriesCollectionView: UICollectionView!
    var valueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchProducts()
        
        valueLabel.text = "50.0"
        
        sliderFilter.isHidden = true
        valueLabel.isHidden = true
    }
    
    func setupUI(){
        //view.backgroundColor = UIColor(hex: "#F5F5F5")
        
        let layout = UICollectionViewFlowLayout()
        categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesCollectionView.topAnchor.constraint(equalTo: sliderFilter.bottomAnchor, constant: 10).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        categoriesCollectionView.backgroundColor = UIColor.clear
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        categoriesCollectionView.register(CustomCategoriesCell.self, forCellWithReuseIdentifier: "brandsCell")
        
        // Set the range for the slider
        sliderFilter.minimumValue = 50.0
        sliderFilter.maximumValue = 500.0
        
        //Add target for value changed event
        sliderFilter.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        // Label setup
        valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(valueLabel)
        
        // Constraints for label
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: categoriesCollectionView.topAnchor, constant: -30),
            valueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            valueLabel.trailingAnchor.constraint(equalTo: sliderFilter.leadingAnchor, constant: -10),
        ])
    }
    
    func fetchProducts() {
        brandProductsViewModel.fetchProducts{ [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching products: \(error)")
            } else {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    @IBAction func filterByPrice(_ sender: UIBarButtonItem) {
        sliderFilter.isHidden.toggle()
        valueLabel.isHidden.toggle()
        
        if !sliderFilter.isHidden {
            filterProductsByCurrentSliderValue()
        }
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let currentValue = String(format: "%.2f", sender.value)
        valueLabel.text = "\(currentValue)"
        
        filterProductsByCurrentSliderValue()
    }
    
    func filterProductsByCurrentSliderValue() {
        if let currentValue = Float(valueLabel.text ?? "50.0") {
            print("Filtering products by price: \(currentValue)")
            brandProductsViewModel.filterProducts(byPrice: currentValue)
            categoriesCollectionView.reloadData()
            print("Reloaded collection view with filtered products.")
        }
    }
    
}

extension BrandsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandProductsViewModel.numberOfProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "brandsCell", for: indexPath) as! CustomCategoriesCell
        
        if let product = brandProductsViewModel.product(at: indexPath.row) {
            print("Displaying product: \(product.name) with price: \(product.variants.first?.price ?? "N/A")")
            cell.nameCategoriesLabel.text = product.name
            cell.priceLabel.text = product.variants.first?.price
            
            if let imageUrlString = product.images.first?.url, let imageUrl = URL(string: imageUrlString) {
                cell.categoriesImgView.kf.setImage(with: imageUrl)
            } else {
                cell.categoriesImgView.image = UIImage(named: "splash-img.jpg")
            }
        }
        
        cell.heartImageView.image = UIImage(systemName: "heart")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 20 , height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let product = brandProductsViewModel.product(at: indexPath.row)
        {
            Navigation.ToProduct(productId: "\(product.id)", from: self)
            
        }
    }
    
}

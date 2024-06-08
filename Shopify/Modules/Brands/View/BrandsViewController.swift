//
//  BrandsViewController.swift
//  Shopify
//
//  Created by Rawan Elsayed on 04/06/2024.
//

import UIKit

class BrandsViewController: UIViewController {
    
   // @IBOutlet weak var sliderFilter: UISlider!
    var brandProductsViewModel = BrandProductsViewModel()
    
    var categoriesCollectionView: UICollectionView!
    var valueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchProducts()
        
        valueLabel.text = "50.0"
    }
    
    func setupUI(){
        //view.backgroundColor = UIColor(hex: "#F5F5F5")
        
        let layout = UICollectionViewFlowLayout()
        categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 210).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        categoriesCollectionView.backgroundColor = UIColor.clear
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        categoriesCollectionView.register(CustomCategoriesCell.self, forCellWithReuseIdentifier: "brandsCell")
        
        // Set the range for the slider
        //sliderFilter.minimumValue = 50.0
        //sliderFilter.maximumValue = 500.0
        
        // Add target for value changed event
        //sliderFilter.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        // Label setup
        valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(valueLabel)
        
        // Constraints for label
        NSLayoutConstraint.activate([
           // valueLabel.topAnchor.constraint(equalTo: sliderFilter.bottomAnchor, constant: 10),
            valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
    
//    @objc func sliderValueChanged(_ sender: UISlider) {
//        let currentValue = String(format: "%.2f", sender.value)
//        valueLabel.text = "\(currentValue)"
//    }

}

extension BrandsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandProductsViewModel.numberOfProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "brandsCell", for: indexPath) as! CustomCategoriesCell
        
        if let product = brandProductsViewModel.product(at: indexPath.row) {
            cell.nameCategoriesLabel.text = product.title
            cell.priceLabel.text = product.variants.first?.price
            
            if let imageUrlString = product.images.first?.src, let imageUrl = URL(string: imageUrlString) {
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
    
}

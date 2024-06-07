//
//  BrandsViewController.swift
//  Shopify
//
//  Created by Rawan Elsayed on 04/06/2024.
//

import UIKit

class BrandsViewController: UIViewController {
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    let categoriesImgs = ["splash-img.jpg", "splash-img.jpg", "splash-img.jpg", "splash-img.jpg", "splash-img.jpg"]
    let categoriesNames = ["category1", "category2", "category3", "category4", "category4"]
    let prices = ["100 $", "200 $" , "180 $" , "220 $", "280 $"]
    
    var categoriesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(hex: "#F5F5F5")
        
        let layout = UICollectionViewFlowLayout()
        categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        categoriesCollectionView.backgroundColor = UIColor.clear
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        categoriesCollectionView.register(CustomCategoriesCell.self, forCellWithReuseIdentifier: "brandsCell")
    }

}

extension BrandsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "brandsCell", for: indexPath) as! CustomCategoriesCell
        
        cell.categoriesImgView.image = UIImage(named: categoriesImgs[indexPath.row])
        cell.nameCategoriesLabel.text = categoriesNames[indexPath.row]
        cell.priceLabel.text = prices[indexPath.row]
        cell.heartImageView.image = UIImage(systemName: "heart")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 20 , height: 260)
    }
    
}

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
        view.backgroundColor = UIColor(hex: "#F5F5F5")
        
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
        
        categoriesCollectionView.register(CustomBrandsCell.self, forCellWithReuseIdentifier: "brandsCell")
    }

}

extension BrandsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "brandsCell", for: indexPath) as! CustomBrandsCell
        
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

class CustomBrandsCell: UICollectionViewCell{
    
    let categoriesImgView = UIImageView()
    let nameCategoriesLabel = UILabel()
    let priceLabel = UILabel()
    let heartImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(categoriesImgView)
        addSubview(nameCategoriesLabel)
        addSubview(priceLabel)
        addSubview(heartImageView)
        
        categoriesImgView.translatesAutoresizingMaskIntoConstraints = false
        nameCategoriesLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoriesImgView.topAnchor.constraint(equalTo: topAnchor , constant: 10),
            categoriesImgView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 10),
            categoriesImgView.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -10),
            categoriesImgView.heightAnchor.constraint(equalToConstant: 180),
            categoriesImgView.bottomAnchor.constraint(equalTo: nameCategoriesLabel.topAnchor),
            
            nameCategoriesLabel.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 10),
            nameCategoriesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameCategoriesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            heartImageView.centerYAnchor.constraint(equalTo: nameCategoriesLabel.centerYAnchor),
            heartImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            heartImageView.widthAnchor.constraint(equalToConstant: 24),
            heartImageView.heightAnchor.constraint(equalToConstant: 24)
            
        ])
                              
        nameCategoriesLabel.textAlignment = .left
        nameCategoriesLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        priceLabel.textAlignment = .left
        priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        categoriesImgView.layer.cornerRadius = 20
        categoriesImgView.layer.masksToBounds = true
        
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(red: 0.25, green: 0.5, blue: 1.0, alpha: 0.05)

        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has been implemented")
    }
    
}

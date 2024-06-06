//
//  CategoriesViewController.swift
//  Shopify
//
//  Created by Rawan Elsayed on 04/06/2024.
//

import UIKit
import JJFloatingActionButton

class CategoriesViewController: UIViewController {
    
    let categoriesImgs = ["splash-img.jpg", "splash-img.jpg", "splash-img.jpg", "splash-img.jpg", "splash-img.jpg"]
    let categoriesNames = ["category1", "category2", "category3", "category4", "category4"]
    let prices = ["100 $", "200 $" , "180 $" , "220 $", "280 $"]
    
    var categoriesCollectionView: UICollectionView!
    
    var fabButton: JJFloatingActionButton!
    var additionalFABsVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor(hex: "#F5F5F5")
        
        let layout = UICollectionViewFlowLayout()
        categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -100).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        categoriesCollectionView.backgroundColor = UIColor.clear
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        categoriesCollectionView.register(CustomCategoriesCell.self, forCellWithReuseIdentifier: "categoriesCell")
        
        fabButton = createFABButton()
        view.addSubview(fabButton)
        fabButton.buttonColor = UIColor(hex: "#FF7D29")

        fabButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            fabButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120)
        ])
    }
    
    func createAdditionalFABButton(imageName: String) -> JJFloatingActionButton {
        let fab = JJFloatingActionButton()
        fab.buttonImage = UIImage(systemName: imageName)
        fab.buttonColor = UIColor(hex: "#FF7D29")
        return fab
    }
    
    func createFABButton() -> JJFloatingActionButton {
        let fab = JJFloatingActionButton()
        fab.buttonColor = UIColor(hex: "#FF7D29")
        fab.addItem(title: nil, image: UIImage(systemName: "line.3.horizontal.decrease")) { item in
            self.toggleAdditionalFABs()
        }
        return fab
    }
    
    func showAdditionalFABs() {
        let option1Fab = createAdditionalFABButton(imageName: "arrow.uturn.backward")
        let option2Fab = createAdditionalFABButton(imageName: "shoe")
        let option3Fab = createAdditionalFABButton(imageName: "tshirt")
        
        view.addSubview(option1Fab)
        view.addSubview(option2Fab)
        view.addSubview(option3Fab)
        
        // Adjust the positions of the additional FABs relative to the main FAB button
        option1Fab.translatesAutoresizingMaskIntoConstraints = false
        option2Fab.translatesAutoresizingMaskIntoConstraints = false
        option3Fab.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            option1Fab.trailingAnchor.constraint(equalTo: fabButton.trailingAnchor),
            option1Fab.bottomAnchor.constraint(equalTo: fabButton.topAnchor, constant: -16),
            option2Fab.trailingAnchor.constraint(equalTo: fabButton.trailingAnchor),
            option2Fab.bottomAnchor.constraint(equalTo: option1Fab.topAnchor, constant: -16),
            option3Fab.trailingAnchor.constraint(equalTo: fabButton.trailingAnchor),
            option3Fab.bottomAnchor.constraint(equalTo: option2Fab.topAnchor, constant: -16)
        ])
        
        additionalFABsVisible = true
    }

    func hideAdditionalFABs() {
        // Remove only the additional FABs from the superview
        for view in view.subviews {
            if let fab = view as? JJFloatingActionButton, fab != fabButton {
                fab.removeFromSuperview()
            }
        }
        additionalFABsVisible = false
    }

    func toggleAdditionalFABs() {
        if additionalFABsVisible {
            hideAdditionalFABs()
        } else {
            showAdditionalFABs()
        }
    }

}


extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! CustomCategoriesCell
        
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

class CustomCategoriesCell: UICollectionViewCell{
    
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

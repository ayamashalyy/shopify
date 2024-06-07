//
//  CustomCategoriesCell.swift
//  Shopify
//
//  Created by Rawan Elsayed on 07/06/2024.
//

import Foundation
import UIKit

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
        contentView.backgroundColor = .clear
        
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has been implemented")
    }
    
}

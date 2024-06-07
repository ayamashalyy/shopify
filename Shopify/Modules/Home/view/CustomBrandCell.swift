//
//  CustomBrandCell.swift
//  Shopify
//
//  Created by Rawan Elsayed on 07/06/2024.
//

import Foundation
import UIKit

class CustomBrandCell: UICollectionViewCell{
    
    let brandImgView = UIImageView()
    let nameBrandLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(brandImgView)
        addSubview(nameBrandLabel)
        
        brandImgView.translatesAutoresizingMaskIntoConstraints = false
        nameBrandLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            brandImgView.topAnchor.constraint(equalTo: topAnchor , constant: 10),
            brandImgView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 10),
            brandImgView.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -10),
            brandImgView.heightAnchor.constraint(equalToConstant: 130),
            brandImgView.bottomAnchor.constraint(equalTo: nameBrandLabel.topAnchor, constant: -10),
            
            nameBrandLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameBrandLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameBrandLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
                              
        nameBrandLabel.textAlignment = .center
        nameBrandLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        brandImgView.layer.cornerRadius = 20
        brandImgView.layer.masksToBounds = true
        
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear

        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.gray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has been implemented")
    }
    
    func configure(with brand: Brand) {
        if let url = URL(string: brand.image.src) {
            brandImgView.kf.setImage(with: url)
        }
        nameBrandLabel.text = brand.title
    }

}

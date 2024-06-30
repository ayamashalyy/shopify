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
       
       contentView.addSubview(brandImgView)
       contentView.addSubview(nameBrandLabel)
          
        brandImgView.translatesAutoresizingMaskIntoConstraints = false
        nameBrandLabel.translatesAutoresizingMaskIntoConstraints = false
        brandImgView.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            brandImgView.topAnchor.constraint(equalTo: topAnchor , constant: 17),
            brandImgView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 10),
            brandImgView.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -10),
            brandImgView.heightAnchor.constraint(equalToConstant: 90),
          
            
            brandImgView.bottomAnchor.constraint(equalTo: nameBrandLabel.topAnchor, constant: -10),
            
            nameBrandLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameBrandLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameBrandLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
                              
        nameBrandLabel.textAlignment = .center
        nameBrandLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        brandImgView.layer.cornerRadius = 20
        brandImgView.layer.masksToBounds = true
        
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = false
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.2
            
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

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    
}



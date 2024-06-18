//
//  summaryCartCell.swift
//  Shopify
//
//  Created by aya on 15/06/2024.
//

import Foundation
import UIKit

class SummaryCartCell: UICollectionViewCell {
    
    let lineItemimageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let quantityLabel = UILabel()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        addSubview(lineItemimageView)
        lineItemimageView.translatesAutoresizingMaskIntoConstraints = false
        lineItemimageView.contentMode = .scaleAspectFill
        lineItemimageView.layer.cornerRadius = 10
        lineItemimageView.layer.masksToBounds = true
        
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(quantityLabel)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        priceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        quantityLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        NSLayoutConstraint.activate([
            lineItemimageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            lineItemimageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            lineItemimageView.widthAnchor.constraint(equalToConstant: 120),
            lineItemimageView.heightAnchor.constraint(equalToConstant: 120),
            lineItemimageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 16),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: lineItemimageView.trailingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 16)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(imageUrl: String?, title: String, price: String, quantity: Int) {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.lineItemimageView.image = image
                    }
                }
            }
        } else {
            lineItemimageView.image = UIImage(named: "4")
        }
        titleLabel.text = title
        priceLabel.text = price
        quantityLabel.text = "Quantity: \(quantity)"
    }
}

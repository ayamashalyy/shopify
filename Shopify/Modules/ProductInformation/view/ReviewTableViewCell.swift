//
//  ReviewTableViewCell.swift
//  Shopify
//
//  Created by mayar on 13/06/2024.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {
    
    let reviewerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let reviewerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let cosmosView: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.settings.updateOnTouch = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(reviewerImageView)
        addSubview(reviewerLabel)
        addSubview(reviewLabel)
        addSubview(cosmosView)
        
        NSLayoutConstraint.activate([
               reviewerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
               reviewerImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
               reviewerImageView.widthAnchor.constraint(equalToConstant: 40),
               reviewerImageView.heightAnchor.constraint(equalToConstant: 40),
               
               reviewerLabel.leadingAnchor.constraint(equalTo: reviewerImageView.trailingAnchor, constant: 10),
               reviewerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
               
               cosmosView.leadingAnchor.constraint(equalTo: reviewerLabel.trailingAnchor, constant: 10),
               cosmosView.centerYAnchor.constraint(equalTo: reviewerLabel.centerYAnchor),
               cosmosView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
               
               reviewLabel.leadingAnchor.constraint(equalTo: reviewerImageView.trailingAnchor, constant: 10),
               reviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
               reviewLabel.topAnchor.constraint(equalTo: reviewerLabel.bottomAnchor, constant: 5),
               reviewLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
           ])
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

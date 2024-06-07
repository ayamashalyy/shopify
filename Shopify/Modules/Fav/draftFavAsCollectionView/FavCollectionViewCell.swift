//
//  FavCollectionViewCell.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class FavCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        setupConstraints()
    }
    
    private func setupCell() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(red: 0.25, green: 0.5, blue: 1.0, alpha: 0.05)
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
}

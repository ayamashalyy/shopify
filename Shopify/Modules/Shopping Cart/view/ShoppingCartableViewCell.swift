//
//  ShoppingCartableViewCell.swift
//  Shopify
//
//  Created by aya on 03/06/2024.
//

import UIKit

class ShoppingCartableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    
    @IBOutlet weak var productView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = false
        contentView.clipsToBounds = false
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.3
        productView.clipsToBounds = false
        productView.layer.cornerRadius = 8
        productView.backgroundColor = .white
        productView.layer.shadowColor = UIColor.black.cgColor
        productView.layer.shadowOffset = CGSize(width: 0, height: 1)
        productView.layer.shadowRadius = 5
        productView.layer.shadowOpacity = 0.3
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        productView.layer.shadowPath = UIBezierPath(roundedRect: productView.bounds, cornerRadius: productView.layer.cornerRadius).cgPath
    }
    
}

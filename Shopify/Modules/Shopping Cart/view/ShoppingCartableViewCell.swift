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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productView: UIView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = false
        containerView.clipsToBounds = false
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.2
        productView.clipsToBounds = false
        productView.layer.cornerRadius = 8
        productView.backgroundColor = .white
        productView.layer.shadowColor = UIColor.black.cgColor
        productView.layer.shadowOffset = CGSize(width: 0, height: 1)
        productView.layer.shadowRadius = 3
        productView.layer.shadowOpacity = 0.2
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: containerView.layer.cornerRadius).cgPath
        productView.layer.shadowPath = UIBezierPath(roundedRect: productView.bounds, cornerRadius: productView.layer.cornerRadius).cgPath
    }
    
}

//
//  OrderViewCell.swift
//  Shopify
//
//  Created by aya on 05/06/2024.
//

import UIKit

class OrderViewCell: UITableViewCell {
    
    @IBOutlet weak var TotalPriceValue: UILabel!
    @IBOutlet weak var CreationDateValue: UILabel!
    //@IBOutlet weak var ShippedToValue: UILabel!
    //@IBOutlet weak var PhoneValue: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = UIColor.white
        containerView.layer.borderColor = UIColor(hex: "#FF7D29").cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 10.0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 2.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}




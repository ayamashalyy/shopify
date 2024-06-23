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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
        contentView.layer.borderColor = UIColor(hex: "#FF7D29").cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 10.0
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}




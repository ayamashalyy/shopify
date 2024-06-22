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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}




//
//  PlaceOrderCell.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//

import UIKit

class PlaceOrderCell: UITableViewCell {
    
    @IBOutlet weak var subTotalLable: UILabel!
    @IBOutlet weak var couponLable: UITextField!
    @IBOutlet weak var discountLable: UILabel!
    @IBOutlet weak var shippingFeesLable: UILabel!
    @IBOutlet weak var gradeTotalLable: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var cancelDiscountHandler: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func cancelDiscount(_ sender: UIButton) {
        cancelDiscountHandler?()
    }
}

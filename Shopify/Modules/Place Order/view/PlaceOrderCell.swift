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
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    var cancelDiscountHandler: (() -> Void)?
    var isDiscountApplied: Bool = false
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
        func updateDiscountPercentage(_ percentage: Int) {
            if percentage > 0 {
                cancelButton.setImage(UIImage(named: "multiply"), for: .normal)
                isDiscountApplied = true
            } else {
                cancelButton.setImage(UIImage(named: "accept"), for: .normal)
                isDiscountApplied = false
            }
        }
        
        @IBAction func cancelDiscount(_ sender: UIButton) {
            cancelDiscountHandler?()
        }
    }

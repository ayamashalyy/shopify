//
//  FavCollectionViewCell.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class FavCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var favButoon: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

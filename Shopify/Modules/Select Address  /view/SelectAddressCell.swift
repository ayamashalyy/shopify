//
//  SelectAddressCell.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//

import UIKit


protocol SelectAddressCellProtocol: AnyObject {
    func editAddress(at indexPath: IndexPath)}

class SelectAddressCell: UITableViewCell {
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: SelectAddressCellProtocol?
    var indexPath: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.clipsToBounds = false
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.2
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: containerView.layer.cornerRadius).cgPath
    }
    
    @IBAction func edit(_ sender: UIButton) {
            if let indexPath = indexPath {
                delegate?.editAddress(at: indexPath)
            }
        }
    
}

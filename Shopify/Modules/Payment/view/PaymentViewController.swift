//
//  PaymentViewController.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var codButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var confirmPay: UIButton!
    @IBOutlet weak var totalPrice: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIButton()
        setupConfirmPayButton()
        
    }
    func setupConfirmPayButton() {
        confirmPay.backgroundColor = UIColor(hex: "#FF7D29")
        confirmPay.setTitleColor(UIColor.white, for: .normal)
        confirmPay.layer.cornerRadius = 10
        confirmPay.clipsToBounds = true
    }
    
    func setUIButton(){
        codButton.setImage(UIImage.init(named: "off"), for: .normal)
        codButton.setImage(UIImage.init(named: "on"), for: .selected)
        appleButton.setImage(UIImage.init(named: "off"), for: .normal)
        appleButton.setImage(UIImage.init(named: "on"), for: .selected)
    }
    
    @IBAction func selectedButtons(_ sender: UIButton) {
        if sender == codButton {
            codButton.isSelected = true
            appleButton.isSelected = false
        }
        else
        {
            codButton.isSelected = false
            appleButton.isSelected = true
        }
    }
    
    @IBAction func Payment(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let PaymentSuccessfulViewController = storyboard.instantiateViewController(withIdentifier: "PaymentSuccessfulViewController") as? PaymentSuccessfulViewController {
            PaymentSuccessfulViewController.modalPresentationStyle = .fullScreen
            present(PaymentSuccessfulViewController, animated: true, completion: nil)
        }
    }


    @IBAction func backToPlaceOrders(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }


}

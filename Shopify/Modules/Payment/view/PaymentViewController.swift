//
//  PaymentViewController.swift
//  Shopify
//
//  Created by aya on 04/06/2024.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var codButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var confirmPay: UIButton!
    @IBOutlet weak var totalPrice: UILabel!
    
    
    let shoppingCartViewModel = ShoppingCartViewModel()
    let orderViewModel = OrderViewModel.shared
    let homeViewModel = HomeViewModel()
    let settingsViewModel = SettingsViewModel()
    let viewModel = ShoppingCartViewModel()
    
    var grandTotal: Double = 0.0
    var isUSD :Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIButton()
        setupConfirmPayButton()
        fetchExchangeRates()
        updateTotalPrice()
        print("grandTotal in view did load in payment \(grandTotal)")

    }
    
    func updateTotalPrice() {
        if isUSD {
            totalPrice.text = "\(grandTotal) USD"

        }else{
            totalPrice.text = "\(grandTotal) EGP"

        }
           orderViewModel.storeGradeTotal("\(grandTotal)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchExchangeRates()
    }
    
    func confirmOrder(){
        shoppingCartViewModel.fetchDraftOrders { error in
            if let error = error {
                print("Error fetching draft orders: \(error)")
            } else {
                print("Draft orders fetched successfully")
                self.orderViewModel.cartViewModel = self.shoppingCartViewModel
                self.orderViewModel.addressViewModel = AddressViewModel()
                self.orderViewModel.settingViewModel = SettingsViewModel()
                
                // create the order
                self.orderViewModel.createOrder { order, error in
                    if let error = error {
                        print("Error creating order: \(error)")
                    } else if let order = order {
                        print("Order created successfully: \(order)")
                        
                        self.viewModel.updateDraftOrderAfterOrder { error in
                            if let error = error {
                                print("Failed to update line items: \(error.localizedDescription)")
                            } else {
                                self.showOrderSuccessAlert()
                                print("updated successfully and sent email inside")
                            }
                        }
                        
                        self.orderViewModel.storeTotalDiscount("0.00")
                        self.homeViewModel.storeDiscountCodeWithPriceRule(code: "", priceRuleValue: 0)
                    }
                }
            }
        }
    }
    func deleteLineItems(){
        viewModel.deleteLineItems { error in
            if let error = error {
                print("Failed to delete line items: \(error.localizedDescription)")
            } else {
                print("Line items deleted successfully")
            }
        }
    }
    
    func fetchExchangeRates() {
        settingsViewModel.fetchExchangeRates { error in
            if let error = error {
                print("Failed to fetch exchange rates: \(error.localizedDescription)")
                return
            }
            self.updateTotalPrice()
            
        }
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
        
        guard CheckNetworkReachability.checkNetworkReachability() else {
            showNoInternetAlert()
            return
        }
            
        if appleButton.isSelected {
            startApplePay()
            print("grade total : \(orderViewModel.fetchGradeTotal())")
            
        } else {
            confirmOrder()
            print("post Successfull of COD")
        }
    }
    
    
    @IBAction func backToPlaceOrders(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private var paymentRequest: PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.pushpendra.pay"
        request.supportedNetworks = [.quicPay, .masterCard, .visa]
        request.supportedCountries = ["EG", "US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        
        if let selectedCurrency = settingsViewModel.getSelectedCurrency() {
            request.currencyCode = selectedCurrency.rawValue
        } else {
            request.currencyCode = "USD"
        }
        
        let selectedCurrency = settingsViewModel.getSelectedCurrency() ?? .USD
        request.currencyCode = selectedCurrency.rawValue
        
        let amount = NSDecimalNumber(value: grandTotal)
        
        let paymentItem = PKPaymentSummaryItem(label: "Shopify", amount: amount)
        request.paymentSummaryItems = [paymentItem]
        
        return request
    }
    
    
    func startApplePay() {
        
        if let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
            paymentVC.delegate = self
            present(paymentVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Apple Pay is not available on this device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    func showOrderSuccessAlert() {
        let alert = UIAlertController(title: "Order Created", message: "Order created successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            Navigation.ToHome(from: self)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let success = true
        if success {
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            showAlert(title: "Success", message: "Payment was successful!")
            performCustomActionForApplePaySuccess()
        } else {
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            showAlert(title: "Failure", message: "Payment failed. Please try again.")
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    
    func performCustomActionForApplePaySuccess() {
        confirmOrder()
        print("post Successfull")
        Navigation.ToHome(from: self)
    }
}





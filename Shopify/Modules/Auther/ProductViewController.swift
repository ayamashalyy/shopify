//
//  ProductViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class ProductViewController: UIViewController ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! reviewTableViewCell
//        let item = cartItems[indexPath.row]
//        cell.productNameLabel.text = "\(item.0)"
//
        return cell
    }

    @IBOutlet weak var scroll: UIScrollView!
    
    
    
    @IBOutlet weak var addToCart: UIButton!
    
    @IBOutlet weak var productFavButton: UIButton!
    
    @IBOutlet weak var imagesVerticalScroll: UIScrollView!
    
    
    
    @IBOutlet weak var basket: UIButton!
    @IBOutlet weak var allBasketButton: UIBarButtonItem!
    
    
    @IBAction func allBasketProduct(_ sender: UIButton) {
    }
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var allFavBtn: UIButton!
    
    
    
    
    @IBAction func productFavBtn(_ sender: UIButton) {
    }
    
    
    @IBAction func addCartAction(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setUpUI()
        }
        
    
    
    func setUpUI (){
        addToCart.backgroundColor = UIColor(hex: "#FF7D29")
        addToCart.layer.cornerRadius = 8
        basket.tintColor = UIColor(hex: "#FF7D29")

   
    }
    
    
    
    
    
    
}

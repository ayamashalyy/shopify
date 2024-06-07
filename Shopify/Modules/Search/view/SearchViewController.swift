//
//  SearchViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchAbout: UITextField!
    
    @IBOutlet weak var serachBtn: UIButton!
    
    @IBAction func serchButoon(_ sender: UIButton) {
        
                         
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serachBtn.backgroundColor = UIColor(hex: "#FF7D29")
        serachBtn.layer.cornerRadius = 8
    }
    


}

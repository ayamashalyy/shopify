//
//  AllFavViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class AllFavViewController: UIViewController {
    
    
    @IBOutlet weak var allFavTable: UITableView!
    
    let favImgs = ["splash-img.jpg", "splash-img.jpg", "splash-img.jpg"]
    let favsNames = ["prodcut1", "product2", "prodcut3"]
    let favPrices = ["10 $", "20 $" , "30 $"]
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        allFavTable.dataSource = self
        allFavTable.delegate = self
        allFavTable.register(UINib(nibName: "WishListViewCell", bundle: nil), forCellReuseIdentifier: "WishListViewCell")
        allFavTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  
    }
}

extension AllFavViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListViewCell", for: indexPath) as! WishListViewCell
        print("WishListViewCell")
        cell.productName.text = favsNames[indexPath.row]
        cell.productPrice.text = favPrices[indexPath.row]
        cell.favImage.image = UIImage(named:favImgs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "third", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "productDetails") as! ProductViewController
        vc.productId = "....."
            self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 60
        }
         

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // here i shoukd remove from data api or realem
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}




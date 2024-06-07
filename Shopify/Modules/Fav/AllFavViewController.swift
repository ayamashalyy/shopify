//
//  AllFavViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class AllFavViewController: UIViewController {
    
    
    @IBOutlet weak var AllFavCollection: UICollectionView!
    
    let categoriesImgs = ["splash-img.jpg", "splash-img.jpg", "splash-img.jpg",  "splash-img.jpg"]
    let categoriesNames = ["category1", "category2", "category3", "category4"]
    let prices = ["100 $", "200 $" , "180 $" , "280 $"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        AllFavCollection.register(UINib(nibName: "FavCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavCell")

    }
}


extension AllFavViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return categoriesImgs.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = AllFavCollection.dequeueReusableCell(withReuseIdentifier: "FavCell", for: indexPath) as! FavCollectionViewCell
            
            cell.image.image = UIImage(named: categoriesImgs[indexPath.row])
            cell.name.text = categoriesNames[indexPath.row]
            cell.priceLabel.text = prices[indexPath.row]
                      
            return cell
        }
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the width and height based on your requirements
        let width = collectionView.frame.width // Example: Use the width of the collection view
        let height: CGFloat = 260 // Example: Set a fixed height
        
        return CGSize(width: width, height: height)
    }

    }


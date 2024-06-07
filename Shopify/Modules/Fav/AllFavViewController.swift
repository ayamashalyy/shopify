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
    
    
    
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//            return 60
//        }
    }

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

  

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



/*   as collection
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

*/

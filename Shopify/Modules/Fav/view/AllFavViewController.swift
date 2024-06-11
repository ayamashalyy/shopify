//
//  AllFavViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class AllFavViewController: UIViewController {
    
    @IBOutlet weak var allFavTable: UITableView!
    
    var favImgs = ["m", "a", "s"]
    var favsNames = ["product1", "product2", "product3"]
    var favPrices = ["10 $", "20 $", "30 $"]
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allFavTable.dataSource = self
        allFavTable.delegate = self
        allFavTable.register(UINib(nibName: "WishListViewCell", bundle: nil), forCellReuseIdentifier: "WishListViewCell")
        allFavTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        checkIfNoData()
    }
    
    func checkIfNoData() {
        if favsNames.isEmpty {
            allFavTable.backgroundView = createNoDataBackgroundView()
        } else {
            allFavTable.backgroundView = nil
        }
    }
    
    func createNoDataBackgroundView() -> UIView {
        // Create image view
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Create label
        let label = UILabel()
        label.text = "No Favorites yet. Add to it"
        label.textColor = .orange
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Create stack view
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create container view
        let containerView = UIView()
        containerView.addSubview(stackView)
        
        // Center stack view in container view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        return containerView
    }
}

extension AllFavViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = favsNames.count
        if count == 0 {
            tableView.backgroundView = createNoDataBackgroundView()
        } else {
            tableView.backgroundView = nil
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListViewCell", for: indexPath) as! WishListViewCell
        print("WishListViewCell")
        cell.productName.text = favsNames[indexPath.row]
        cell.productPrice.text = favPrices[indexPath.row]
        cell.favImage.image = UIImage(named: favImgs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Navigation.ToProduct(productId: "8575847989496", from: self)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from your data source (e.g., API or Realm)
            favsNames.remove(at: indexPath.row)
            favPrices.remove(at: indexPath.row)
            favImgs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            checkIfNoData()
        }
    }
}

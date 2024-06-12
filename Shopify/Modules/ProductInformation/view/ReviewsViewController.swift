//
//  ReviewsViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class ReviewsViewController: UIViewController {
    

    @IBOutlet weak var reviewsTableView: UITableView!
    
    var reviews = [(reviewer: String, reviewText: String, ourImage :String)]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            reviewsTableView.delegate = self
            reviewsTableView.dataSource = self
            reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReviewCell")
        }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }

    }

    extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
        

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return reviews.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
            let review = reviews[indexPath.row]
            
            var content = cell.defaultContentConfiguration()
            content.text = review.1
            content.secondaryText = review.0
          //  content.image = UIImage(named: review.2)
            cell.contentConfiguration = content
            
            return cell
        }
    }

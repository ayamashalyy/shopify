//
//  ReviewsViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    @IBOutlet weak var reviewsTableView: UITableView!
    
        var reviews = [(reviewer: String, reviewText: String)]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            reviewsTableView.delegate = self
            reviewsTableView.dataSource = self
            reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReviewCell")
            
        }
    }

    extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return reviews.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
            let review = reviews[indexPath.row]
            
            cell.textLabel?.text = review.reviewText
            cell.detailTextLabel?.text = review.reviewer
            
            return cell
        }
    }

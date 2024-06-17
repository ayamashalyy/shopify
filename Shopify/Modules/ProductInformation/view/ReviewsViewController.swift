//
//  ReviewsViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//

import UIKit
import Cosmos

class ReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsTableView: UITableView!

    var reviews = [(reviewer: String, reviewText: String, ourImage: String, rating: Double)]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: "ReviewTableViewCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        let review = reviews[indexPath.row]
        
        cell.reviewLabel.text = review.reviewText
        cell.reviewerLabel.text = review.reviewer
        cell.cosmosView.rating = review.rating
        if let image = UIImage(named: review.ourImage) {
            cell.reviewerImageView.image = image
        } else {
            cell.reviewerImageView.image = UIImage(named: "splash")
        }
        
        return cell
    }
}

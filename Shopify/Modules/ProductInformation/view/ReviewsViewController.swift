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
            setupTableHeader()
        }
    
     func setupTableHeader() {
         let headerView = UIView(frame: CGRect(x: 0, y: 0, width: reviewsTableView.frame.width, height: 44))
         headerView.backgroundColor = .systemGray6

         let label = UILabel()
         label.text = "Product Reviews:"
         label.font = UIFont.boldSystemFont(ofSize: 18)
         label.translatesAutoresizingMaskIntoConstraints = false

         headerView.addSubview(label)
         
         NSLayoutConstraint.activate([
             label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
             label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
             label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
             label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
         ])
         
         reviewsTableView.tableHeaderView = headerView
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
            cell.contentConfiguration = content
            
            return cell
        }
    }

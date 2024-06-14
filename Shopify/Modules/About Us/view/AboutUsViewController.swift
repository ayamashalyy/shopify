//
//  AboutUsViewController.swift
//  Shopify
//
//  Created by aya on 12/06/2024.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
      

    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "About Us"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        let missionLabel = UILabel()
        missionLabel.text = "Welcome to Shopify! Our mission is to make commerce better for everyone, so businesses can focus on what they do best: building and selling their products. We strive to empower entrepreneurs everywhere by providing the tools and resources they need to succeed."
        missionLabel.numberOfLines = 0
        missionLabel.textAlignment = .center
        
        let storyLabel = UILabel()
        storyLabel.text = "Our Story: Founded in 2024, Shopify was created to solve the problem of having to build your own online store from scratch. Since then, we've been dedicated to simplifying commerce for millions of businesses worldwide, enabling entrepreneurs to start, run, and grow their own businesses."
        storyLabel.numberOfLines = 0
        storyLabel.textAlignment = .center
        
        let teamLabel = UILabel()
        teamLabel.text = "Our Team: Our team is composed of passionate and dedicated professionals who specialize in various areas such as technology, customer service, and business development. We're committed to creating the best possible experience for our users."
        teamLabel.numberOfLines = 0
        teamLabel.textAlignment = .center
        
        let contactLabel = UILabel()
        contactLabel.text = "Contact Us: We love hearing from our users! If you have any questions, feedback, or suggestions, please don't hesitate to reach out to us at support@shopify.com."
        contactLabel.numberOfLines = 0
        contactLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, missionLabel, storyLabel, teamLabel, contactLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
}

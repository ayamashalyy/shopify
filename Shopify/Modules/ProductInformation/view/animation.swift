//
//  animation.swift
//  Shopify
//
//  Created by mayar on 11/06/2024.
//

import Foundation

import UIKit

extension UIViewController {
    func showCheckMarkAnimation(mark:String) {
        let checkMarkView = UIImageView()
        checkMarkView.image = UIImage(systemName: mark)
        checkMarkView.tintColor = .orange
        checkMarkView.alpha = 0.0
        checkMarkView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(checkMarkView)
        
        NSLayoutConstraint.activate([
            checkMarkView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            checkMarkView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            checkMarkView.widthAnchor.constraint(equalToConstant: 100),
            checkMarkView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        UIView.animate(withDuration: 0.3, animations: {
            checkMarkView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
                checkMarkView.alpha = 0.0
            }) { _ in
                checkMarkView.removeFromSuperview()
            }
        }
    }
}

//
//  OnbordingViewController.swift
//  Shopify
//
//  Created by aya on 03/06/2024.
//

import UIKit

class OnbordingViewController: UIViewController {

    
    @IBOutlet weak var myview: UIView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descritpion: UILabel!
    @IBOutlet weak var start : UIButton!


    var pageIndex: Int!
    var imageFileName: String!
    var titl: String!
    var descrit: String!
    

    
    @IBAction func start(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true) {
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            }
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            myImage.image = UIImage(named: imageFileName)
            titleLabel.text = titl
            descritpion.text = descrit
            
            myview.layer.masksToBounds = true
            myview.clipsToBounds = false
            myview.layer.cornerRadius = 8
            myview.backgroundColor = .white
            myview.layer.shadowColor = UIColor.black.cgColor
            myview.layer.shadowOffset = CGSize(width: 0, height: 1)
            myview.layer.shadowRadius = 5
            myview.layer.shadowOpacity = 0.2
            
        }
}

//
//  HomeViewController.swift
//  Shopify
//
//  Created by aya on 03/06/2024.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    let brandsImgs = ["splash-img.jpg", "splash-img.jpg", "splash-img.jpg", "splash-img.jpg"]
    let brandsNames = ["brand1", "brand2", "brand3", "brand4"]
    
    var brandsCollectionView: UICollectionView!
    
    let coponesImages = ["splash-img.jpg", "splash-img.jpg", "splash-img.jpg"]
    var couponsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#F5F5F5")
        
        let layout = UICollectionViewFlowLayout()
        brandsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        view.addSubview(brandsCollectionView)
        
        // Setup couponsCollectionView
        let couponLayout = UICollectionViewFlowLayout()
        couponLayout.scrollDirection = .horizontal
        couponsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: couponLayout)
        view.addSubview(couponsCollectionView)
        couponsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            couponsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            couponsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            couponsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            couponsCollectionView.heightAnchor.constraint(equalToConstant: 210)
        ])

        couponsCollectionView.backgroundColor = UIColor.clear
        couponsCollectionView.dataSource = self
        couponsCollectionView.delegate = self

        couponsCollectionView.register(CustomCouponCell.self, forCellWithReuseIdentifier: "couponCell")
        
        let brandsTitleLabel = UILabel()
        brandsTitleLabel.text = "Brands"
        brandsTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        brandsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brandsTitleLabel)
        
        NSLayoutConstraint.activate([
            brandsTitleLabel.topAnchor.constraint(equalTo: couponsCollectionView.bottomAnchor, constant: 20),
            brandsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            brandsTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            brandsTitleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])

        
        brandsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        brandsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 430).isActive = true
        brandsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -100).isActive = true
        brandsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        brandsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        brandsCollectionView.backgroundColor = UIColor.clear
        brandsCollectionView.dataSource = self
        brandsCollectionView.delegate = self
        
        brandsCollectionView.register(CustomBrandCell.self, forCellWithReuseIdentifier: "brandCell")

    }

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == couponsCollectionView {
            return coponesImages.count
        } else {
            return brandsImgs.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == couponsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "couponCell", for: indexPath) as! CustomCouponCell
            cell.imageView.image = UIImage(named: coponesImages[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! CustomBrandCell
            cell.brandImgView.image = UIImage(named: brandsImgs[indexPath.item])
            cell.nameBrandLabel.text = brandsNames[indexPath.item]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == couponsCollectionView {
            return CGSize(width: view.frame.width, height: 260)
        } else {
            return CGSize(width: view.frame.width / 2 - 20, height: 180)
        }
    }
}

class CustomBrandCell: UICollectionViewCell{
    
    let brandImgView = UIImageView()
    let nameBrandLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(brandImgView)
        addSubview(nameBrandLabel)
        
        brandImgView.translatesAutoresizingMaskIntoConstraints = false
        nameBrandLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            brandImgView.topAnchor.constraint(equalTo: topAnchor , constant: 10),
            brandImgView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 10),
            brandImgView.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -10),
            brandImgView.heightAnchor.constraint(equalToConstant: 130),
            brandImgView.bottomAnchor.constraint(equalTo: nameBrandLabel.topAnchor, constant: -10),
            
            nameBrandLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameBrandLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameBrandLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
                              
        nameBrandLabel.textAlignment = .center
        nameBrandLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        brandImgView.layer.cornerRadius = 20
        brandImgView.layer.masksToBounds = true
        
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(red: 0.25, green: 0.5, blue: 1.0, alpha: 0.05)

        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.gray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has been implemented")
    }
    
}

class CustomCouponCell: UICollectionViewCell {

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 230)
        ])
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  HomeViewController.swift
//  Shopify
//
//  Created by aya on 03/06/2024.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    

    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var scrollView: UIScrollView!
    
    let brandsImgs = ["splash-img.jpg", "splash-img.jpg", "splash-img.jpg", "splash-img.jpg"]
    let brandsNames = ["brand1", "brand2", "brand3", "brand4"]
    
    var brandsCollectionView: UICollectionView!
    
    let coponesImages = ["splash-img.jpg", "splash-img.jpg", "splash-img.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#F5F5F5")
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl.numberOfPages = coponesImages.count
        pageControl.currentPage = 0
        
        for i in 0..<coponesImages.count{
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.image = UIImage(named: coponesImages[i])
            let xpos = CGFloat(i)*self.view.bounds.size.width
            imageView.frame = CGRect(x: xpos, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height)
            scrollView.contentSize.width = view.frame.size.width*CGFloat(i+1)
            scrollView.addSubview(imageView)
        }
        
        let layout = UICollectionViewFlowLayout()
        brandsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        view.addSubview(brandsCollectionView)
        
        brandsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        brandsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        brandsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -100).isActive = true
        brandsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        brandsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        brandsCollectionView.backgroundColor = UIColor.clear
        brandsCollectionView.dataSource = self
        brandsCollectionView.delegate = self
        
        brandsCollectionView.register(CustomBrandCell.self, forCellWithReuseIdentifier: "brandCell")

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        
        pageControl.currentPage = Int(page)
    }

}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandsImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = brandsCollectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! CustomBrandCell
        
        cell.brandImgView.image = UIImage(named: brandsImgs[indexPath.row])
        cell.nameBrandLabel.text = brandsNames[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 20 , height: 180)
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

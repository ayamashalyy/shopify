//
//  HomeViewController.swift
//  Shopify
//
//  Created by aya on 03/06/2024.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController, UIScrollViewDelegate {
        
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var brandsCollectionView: UICollectionView!
    let homeViewModel = HomeViewModel()
    let brandProductsViewModel = BrandProductsViewModel()
    
    let coponesImages = ["eid_sale.jpeg", "sum3_disc30.jpeg","sum1_disc30.jpeg"]
    var couponsCollectionView: UICollectionView!
    
    
    @IBAction func goToFav(_ sender: UIBarButtonItem) {
        print("go to favss from home")
        Navigation.ToAllFavourite(from: self)
        print("go to favss from home after")
        
    }
    @IBAction func goToSearch(_ sender: UIBarButtonItem) {
        Navigation.ToSearch(from: self, comeFromHome: true, products: [])
    }
    
    @IBAction func goToCard(_ sender: UIBarButtonItem) {
        Navigation.ToOrders(from: self)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicator.startAnimating()
        setupUI()
        fetchBrands()
        fetchPriceRules()
    }
    func fetchBrands() {
        homeViewModel.fetchBrands { [weak self] error in
            guard let self = self else { return }
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            if let error = error {
                print("Error fetching brands: \(error)")
            } else {
                self.brandsCollectionView.reloadData()
            }
        }
    }
    
    func fetchDiscountCodesAndShowAlert(for indexPath: IndexPath) {
        guard let priceRule = homeViewModel.priceRule(at: indexPath.item) else {
            print("Invalid price rule at index \(indexPath.item)")
            return
        }
        
        homeViewModel.fetchDiscountCodes { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching discount codes: \(error)")
            } else {
                let discountCode = self.homeViewModel.discountCodes.first(where: { $0.price_rule_id == priceRule.id })?.code ?? "No Code"
                self.showDiscountCodeAlert(code: discountCode, discountPercentage: priceRule.value, indexPath: indexPath)
            }
        }
    }
    
    func fetchPriceRules(){
        homeViewModel.fetchPriceRules { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching price rules: \(error)")
            } else {
                // Price rules fetched successfully
                print("Price rules IDs: \(self.homeViewModel.priceRules.map { $0.id })")
            }
        }
    }
    
    func setupUI(){
        //view.backgroundColor = UIColor(hex: "#F5F5F5")

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
            couponsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            couponsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            couponsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            couponsCollectionView.heightAnchor.constraint(equalToConstant: 190)
        ])

        couponsCollectionView.backgroundColor = UIColor.clear
        couponsCollectionView.dataSource = self
        couponsCollectionView.delegate = self

        couponsCollectionView.register(CustomCouponCell.self, forCellWithReuseIdentifier: "couponCell")
        
        //Setup Brands Label
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

        //Setup BrandsCollectionView
        brandsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        brandsCollectionView.topAnchor.constraint(equalTo: brandsTitleLabel.bottomAnchor, constant: 10).isActive = true
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
            return homeViewModel.numberOfBrands()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == couponsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "couponCell", for: indexPath) as! CustomCouponCell
            cell.imageView.image = UIImage(named: coponesImages[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! CustomBrandCell
            if let brand = homeViewModel.brand(at: indexPath.item) {
                cell.configure(with: brand)
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == couponsCollectionView {
            return CGSize(width: view.frame.width, height: 260)
        } else {
            return CGSize(width: view.frame.width / 2 - 20, height: 190)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == brandsCollectionView {
            guard let brand = homeViewModel.brand(at: indexPath.item) else { return }
            
            guard let brandsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandsViewController") as? BrandsViewController else {
                return
            }
            // Pass collectionId to BrandsViewController
            brandsVC.brandProductsViewModel.setCollectionId(brand.id)
            brandsVC.modalPresentationStyle = .fullScreen
            self.present(brandsVC, animated: true, completion: nil)
            
        } else if collectionView == couponsCollectionView {
            fetchDiscountCodesAndShowAlert(for: indexPath)
        }
    }
    
    private func showDiscountCodeAlert(code: String, discountPercentage: String, indexPath: IndexPath) {
        guard let priceRuleValue = homeViewModel.priceRules[indexPath.item].discountValue else {
            print("Error: Price rule value not available")
            return
        }
        
        let message = "Here is a discount code with \(priceRuleValue)% off: \(code) , do you want to get it"
        let alert = UIAlertController(title: "Discount Code", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Store discount code with price rule value in UserDefaults
            self.homeViewModel.storeDiscountCodeWithPriceRule(code: code, priceRuleValue: priceRuleValue)
            print("added to the user defaults")
            if let storedDiscountDict = self.homeViewModel.fetchStoredDiscountCode(),
               let storedCode = storedDiscountDict["code"] as? String {
                print("Stored discount code: \(storedCode)")
            } else {
                print("No stored discount code found")
            }
            if let storedDiscountDict2 = self.homeViewModel.fetchStoredDiscountCode(),
               let storedValue = storedDiscountDict2["priceRuleValue"] as? Int {
                print("Stored discount value: \(storedValue)")
            } else {
                print("No stored discount value found")
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }

}

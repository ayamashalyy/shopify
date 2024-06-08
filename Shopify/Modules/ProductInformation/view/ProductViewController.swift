//
//  ProductViewController.swift
//  Shopify
//
//  Created by mayar on 06/06/2024.
//




import UIKit
import Cosmos
import Kingfisher

class ProductViewController: UIViewController {
    
    var productId : String? = "8575848153336"
    var productViewModel : ProductViewModel?
    let indicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("inproduct the id\(productId)")
        setUpUI()
        myCollectionOfImages.delegate = self
        myCollectionOfImages.dataSource = self
        productViewModel = ProductViewModel()
        productViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let product = self.productViewModel?.product else { return }
                let imageUrl = product.images
                self.setupStackView(name: product.name,
                                    price: "$\(product.variants.first?.price ?? "")",
                                    description: product.description,
                                    sizes: product.variants.first?.size ?? "")

                self.myCollectionOfImages.reloadData()
                self.pageContoller.numberOfPages = product.images.count

                self.indicator.stopAnimating()
            }
        }
        productViewModel?.getProductDetails(id: productId!)
        
    }
    // the data from api not conatin reviews and not contain rate
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var productFavButton: UIButton!
    @IBOutlet weak var basket: UIButton!
    @IBOutlet weak var allBasketButton: UIBarButtonItem!
    @IBOutlet weak var myCollectionOfImages: UICollectionView!
    
    @IBAction func showFaviourts(_ sender: UIButton) {
        print("show all fav")
        Navigation.ToAllFavourite(from: self)
    }
    
    
    @IBOutlet weak var pageContoller: UIPageControl!
    @IBAction func allBasketProduct(_ sender: UIButton) {
        print("show all basket")
        Navigation.ToOrders(from: self)
    }
    
    @IBAction func productFavBtn(_ sender: UIButton) {
        
        print("show add to fav")
        
    }
    
    
    @IBAction func addCartAction(_ sender: UIButton) {
        
        print("show add to cart")
        
    }
    
    func setUpUI (){
        addToCart.backgroundColor = UIColor(hex: "#FF7D29")
        addToCart.layer.cornerRadius = 8
        basket.tintColor = UIColor(hex: "#FF7D29")
        scroll.contentSize = CGSize(width: 0, height: scroll.contentSize.height)
        indicator.center = self.view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    func setupStackView(name: String, price: String, description: String, sizes: String) {
        
        let nameText =  UITextView()
        nameText.text = name
        nameText.isScrollEnabled = false
        nameText.isEditable = false
        nameText.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let priceLabel = UILabel()
        priceLabel.text = price
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        let sizesLabel = UILabel()
        sizesLabel.text = "Available Sizes: \(sizes)"
        sizesLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let ratingView = CosmosView()
        ratingView.settings.updateOnTouch = false
        ratingView.rating = 4
        
        let descriptionTextView = UITextView()
        descriptionTextView.text = description
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let reviewsHeader = UILabel()
        reviewsHeader.text = "Reviews"
        reviewsHeader.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let reviewsTableView = UITableView()
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.isScrollEnabled = false
        reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReviewCell")
        
        stack.addArrangedSubview(nameText)
        stack.addArrangedSubview(priceLabel)
        stack.addArrangedSubview(sizesLabel)
        stack.addArrangedSubview(ratingView)
        stack.addArrangedSubview(descriptionTextView)
        stack.addArrangedSubview(reviewsHeader)
        stack.addArrangedSubview(reviewsTableView)
        
        NSLayoutConstraint.activate([
            reviewsTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let seeMoreButton = UIButton(type: .system)
        seeMoreButton.setTitle("See More", for: .normal)
        seeMoreButton.addTarget(self, action: #selector(seeMoreReviews), for: .touchUpInside)
        
        stack.addArrangedSubview(seeMoreButton)
        stack.setCustomSpacing(20, after: reviewsTableView)
    }
    
    @objc func seeMoreReviews() {
        let storyboard = UIStoryboard(name: "third", bundle: nil)
        let reviewsVC = storyboard.instantiateViewController(withIdentifier: "ReviewsViewController") as! ReviewsViewController
        reviewsVC.reviews = ProductViewModel.getReviews()
        self.navigationController?.pushViewController(reviewsVC, animated: true)
    }
}
    extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return productViewModel?.product?.images.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsimagesCollectionViewCell", for: indexPath) as! ProductsimagesCollectionViewCell
            if let imageUrl = productViewModel?.product?.images[indexPath.row].url {
                cell.productPhoto.kf.setImage(with: URL(string: imageUrl))
            }
            return cell
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let pageWidth = scrollView.frame.size.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageContoller.currentPage = currentPage
        }
    }

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var arrayOfReviews = ProductViewModel.getReviews()
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
        let review = arrayOfReviews[indexPath.row]
                    
        var content = cell.defaultContentConfiguration()
        content.text = review.1
        content.secondaryText = review.0
        cell.contentConfiguration = content
        
        return cell
    }

}
/*
import UIKit
import Cosmos

class ProductViewController: UIViewController {
    
    var productId : String?
    // the data from api not conatin reviews and not contain rate
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var productFavButton: UIButton!
    @IBOutlet weak var basket: UIButton!
    @IBOutlet weak var allBasketButton: UIBarButtonItem!
    @IBOutlet weak var myCollectionOfImages: UICollectionView!
   
    
    
    
    @IBAction func showFaviourts(_ sender: UIButton) {
        print("show all fav")
        Navigation.ToAllFavourite(from: self)
    }
    
    
    @IBOutlet weak var pageContoller: UIPageControl!
    @IBAction func allBasketProduct(_ sender: UIButton) {
        print("show all basket")
        Navigation.ToOrders(from: self)
    }
                
    @IBAction func productFavBtn(_ sender: UIButton) {
        
        print("show add to fav")

    }
    
    
    @IBAction func addCartAction(_ sender: UIButton) {
                
        print("show add to cart")
        
    }

    var imageArrary = [UIImage(named: "payment")!,UIImage(named: "payment")!]
    
    var reviews = [
        ("John Doe", "Great product!"),
        ("Jane Smith", "Not worth the price."),
        ("Jane Smith", "Not worth the price."),
        ("Alice Johnson", "Average quality.")
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        print("inproduct the id\(productId)")
        setUpUI()
        myCollectionOfImages.delegate = self
        myCollectionOfImages.dataSource = self
        pageContoller.numberOfPages = imageArrary.count
        setupStackView()

        
    }
    
    func setUpUI (){
        addToCart.backgroundColor = UIColor(hex: "#FF7D29")
        addToCart.layer.cornerRadius = 8
        basket.tintColor = UIColor(hex: "#FF7D29")
        scroll.contentSize = CGSize(width: 0, height: scroll.contentSize.height)
    }
    
    func setupStackView() {
           let nameLabel = UILabel()
           nameLabel.text = "Product Name"
           nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
           
           let priceLabel = UILabel()
           priceLabel.text = "$99.99"
           priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
           
           let sizesLabel = UILabel()
           sizesLabel.text = "Available Sizes: S, M, L, XL"
           sizesLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
           
           let ratingView = CosmosView()
           ratingView.settings.updateOnTouch = false
           ratingView.rating = 4.5
           
           let descriptionTextView = UITextView()
           descriptionTextView.text = "This is a great product description.This is a great product description.This is a great product description.This is a great product description."
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false

           descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
           
           let reviewsHeader = UILabel()
           reviewsHeader.text = "Reviews"
           reviewsHeader.font = UIFont.systemFont(ofSize: 20, weight: .bold)
           
            let reviewsTableView = UITableView()
           reviewsTableView.delegate = self
           reviewsTableView.dataSource = self
           reviewsTableView.isScrollEnabled = false
           reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReviewCell")
           
           stack.addArrangedSubview(nameLabel)
           stack.addArrangedSubview(priceLabel)
           stack.addArrangedSubview(sizesLabel)
           stack.addArrangedSubview(ratingView)
           stack.addArrangedSubview(descriptionTextView)
           stack.addArrangedSubview(reviewsHeader)
           stack.addArrangedSubview(reviewsTableView)
        NSLayoutConstraint.activate([
               reviewsTableView.heightAnchor.constraint(equalToConstant: 200)
           ])

           let seeMoreButton = UIButton(type: .system)
           seeMoreButton.setTitle("See More", for: .normal)
           seeMoreButton.addTarget(self, action: #selector(seeMoreReviews), for: .touchUpInside)
           
           stack.addArrangedSubview(seeMoreButton)
           stack.setCustomSpacing(20, after: reviewsTableView)
       }
       
    @objc func seeMoreReviews() {
        let storyboard = UIStoryboard(name: "third", bundle: nil)
         let reviewsVC = storyboard.instantiateViewController(withIdentifier: "ReviewsViewController") as! ReviewsViewController
            reviewsVC.reviews = self.reviews
            self.navigationController?.pushViewController(reviewsVC, animated: true)
        
    }

}
 

extension ProductViewController :  UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArrary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsimagesCollectionViewCell", for: indexPath) as! ProductsimagesCollectionViewCell
        cell.productPhoto.image = imageArrary[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let pageWidth = scrollView.frame.size.width
           let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageContoller.currentPage = currentPage
       }
    
    
}


extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
*/

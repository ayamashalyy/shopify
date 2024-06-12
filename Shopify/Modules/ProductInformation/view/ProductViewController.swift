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
    
    let settingsViewModel = SettingsViewModel()
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func goToCard(_ sender: UIBarButtonItem) {
        Navigation.ToOrders(from: self)
    }
    
    @IBAction func goToAllFaviourt(_ sender: UIBarButtonItem) {
        Navigation.ToAllFavourite(from: self)
    }
    
    var productId: String?
    var productViewModel: ProductViewModel?
    let indicator = UIActivityIndicatorView(style: .large)
    var firstImageURL : String?
    override func viewDidLoad() {
            super.viewDidLoad()
        fetchExchangeRates()
            
            print("in product the id \(productId ?? "")")
            setUpUI()
            myCollectionOfImages.delegate = self
            myCollectionOfImages.dataSource = self
            productViewModel = ProductViewModel()
            productViewModel?.bindResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self, let product = self.productViewModel?.product else { return }
                    let imageUrl = product.images
                    self.firstImageURL =  product.images.first?.url
                    self.setupStackView(name: product.name,
                                        price: "$\(product.variants.first?.price ?? "")",
                                        description: product.description,
                                        variants: product.variants)

                    self.myCollectionOfImages.reloadData()
                    self.pageContoller.numberOfPages = product.images.count

                    self.indicator.stopAnimating()
                }
            }
            productViewModel?.getProductDetails(id: productId!)
        }
    
    // The data from API not containing reviews and not containing rate
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
        // Assuming `productId` and `firstImageURL` are properties of your class
          guard let productIdString = productId, let firstImageURL = firstImageURL else {
              showAlert(message: "The product not loaded yet")
              return
          }
          
          // Convert productId to an integer
          if let productIdInt = Int(productIdString) {
              productViewModel?.addToFavDraftOrders(selectedVariantsData: [(productIdInt, firstImageURL)])
          } else {
              showAlert(message: "Invalid product ID")
          }
    }
    
    @IBOutlet weak var addToCard: UIButton!
    var isButtonClicked = false

    
    @IBAction func addCartAction(_ sender: UIButton) {
        
        if isButtonClicked {
                   return
               }
        isButtonClicked = true
        addToCard.isEnabled = false
        
        
        var selectedVariants: [String] = []
        var selectedVariantsIDsAndImageUrl: [(Int ,String)] = []

        for subview in stack.arrangedSubviews {
            
                   if let variantStackView = subview as? UIStackView,
                      let variantButton = variantStackView.arrangedSubviews.first as? UIButton,
                      let checkmarkImageView = variantStackView.arrangedSubviews.last as? UIImageView,
                      !checkmarkImageView.isHidden {
                       if let variantText = variantButton.titleLabel?.text {
                           selectedVariants.append(variantText)

                           for variant in productViewModel?.product?.variants ?? [] {
                            if ("Size: \(variant.size), Color: \(variant.color ?? "N/A"), Price: \(variant.price)$" == variantText) {
                                if let imageUrl = productViewModel?.product?.images.first?.url {
                                 selectedVariantsIDsAndImageUrl.append((id: variant.id, imageUrl: imageUrl))
                                }
                          }
                       }
                       }
                   }
               }
        
      print("In view controller \(selectedVariantsIDsAndImageUrl)")
     productViewModel?.addToCartDraftOrders( selectedVariantsData: selectedVariantsIDsAndImageUrl)
//        if isAddedToCard! {
//            showAlert(message: "Added to your card")
//        }
    }

    
    
    func setUpUI() {
        addToCart.backgroundColor = UIColor(hex: "#FF7D29")
        addToCart.layer.cornerRadius = 8
        basket.tintColor = UIColor(hex: "#FF7D29")
        scroll.contentSize = CGSize(width: 0, height: scroll.contentSize.height)
        indicator.center = self.view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    
    func setupStackView(name: String, price: String, description: String, variants: [Variant]) {
        let nameText = UITextView()
        nameText.text = name
        nameText.isScrollEnabled = false
        nameText.isEditable = false
        nameText.font = UIFont.systemFont(ofSize: 20, weight: .bold)

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
       
        let availableSizeAndColorLabel = UILabel()
          availableSizeAndColorLabel.text = "Available Size and Color:"
          availableSizeAndColorLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        
        stack.addArrangedSubview(nameText)
        stack.addArrangedSubview(ratingView)
        stack.addArrangedSubview(descriptionTextView)
        stack.addArrangedSubview(availableSizeAndColorLabel)
        
        for variant in variants {
            let variantStackView = UIStackView()
            variantStackView.axis = .horizontal
            variantStackView.spacing = 8
         
            
            let variantButton = UIButton(type: .system)
//            variantButton.setTitle("Size: \(variant.size), Color: \(variant.color ?? "N/A"), Price: \(variant.price)$", for: .normal)
            
            //Handle the currency 
            if let selectedCurrency = settingsViewModel.getSelectedCurrency() {
                let convertedPrice = settingsViewModel.convertPrice(variant.price, to: selectedCurrency)
                variantButton.setTitle("Size: \(variant.size), Color: \(variant.color ?? "N/A"), Price: \(convertedPrice ?? variant.price)", for: .normal)
            } else {
                variantButton.setTitle("Size: \(variant.size), Color: \(variant.color ?? "N/A"), Price: \(variant.price)$", for: .normal)
            }
            
            print ("0000Size: \(variant.size), Color: \(variant.color ?? "N/A"), Price: \(variant.price)$")
            
            print("Size varianmt \(variant.id)")
            
            variantButton.setTitleColor(.black, for: .normal)
            variantButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)

            variantButton.addTarget(self, action: #selector(variantButtonTapped(_:)), for: .touchUpInside)
            
            let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmarkImageView.tintColor = .orange
            checkmarkImageView.contentMode = .scaleAspectFit
            checkmarkImageView.isHidden = true
            
            variantStackView.addArrangedSubview(variantButton)
            variantStackView.addArrangedSubview(checkmarkImageView)
            stack.addArrangedSubview(variantStackView)
        }


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


    @objc func variantButtonTapped(_ sender: UIButton) {
        guard let variantStackView = sender.superview as? UIStackView,
              let checkmarkImageView = variantStackView.arrangedSubviews.last as? UIImageView else {
            return
        }
        print("Variant button tapped: \(sender.titleLabel?.text ?? "")")
        // Toggle checkmark image visibility
        checkmarkImageView.isHidden = !checkmarkImageView.isHidden
    }
    
    @objc func seeMoreReviews() {
        let storyboard = UIStoryboard(name: "third", bundle: nil)
        let reviewsVC = storyboard.instantiateViewController(withIdentifier: "ReviewsViewController") as! ReviewsViewController
        reviewsVC.reviews = ProductViewModel.getReviews()
        reviewsVC.modalPresentationStyle = .fullScreen
        present(reviewsVC, animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
           let alertController = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alertController, animated: true, completion: nil)
       }
    
    func fetchExchangeRates(){
        settingsViewModel.fetchExchangeRates { [weak self] error in
            if let error = error {
                print("Error fetching exchange rates: \(error)")
            } else {
                // Reload data once exchange rates are fetched
                //self?.categoriesCollectionView.reloadData()
            }
        }
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

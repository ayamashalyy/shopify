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
    var productId: String?
    var productViewModel: ProductViewModel?
    let indicator = UIActivityIndicatorView(style: .large)
    var firstImageURL : String?
    var firstVariantId : Int?
    var isComeFromFaviourts: Bool?
    var selectedVarientId : Int?
    var isFav = false
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var productFavButton: UIButton!
    @IBOutlet weak var basket: UIButton!
    @IBOutlet weak var myCollectionOfImages: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExchangeRates()
        
        //  print("in product the id \(productId ?? "")")
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
                
                if self.isComeFromFaviourts == true
                {
                    //            print("is come from fav")
                    self.updateFavButton(iscomefromFav: true)
                    self.isFav =  true
                    
                }
                else{
                    //             print("is noooooot come from fav")
                    
                    self.productViewModel?.checkIsFav(imageUrl: self.firstImageURL ?? "") { isInFav in
                        self.updateFavButton(iscomefromFav: isInFav)
                        self.isFav = isInFav
                        
                    }
                }
                self.myCollectionOfImages.reloadData()
                self.pageContoller.numberOfPages = product.images.count
                
                self.indicator.stopAnimating()
            }
        }
        if  CheckNetworkReachability.checkNetworkReachability(){
            productViewModel?.getProductDetails(id: productId!)
        }else {
            showAlert(message: "Failed to get product details as lost network connection")
        }
        
    }
    
    func updateFavButton(iscomefromFav: Bool) {
        if iscomefromFav {
            productFavButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            productFavButton.tintColor = .red
            
        } else {
            productFavButton.setImage(UIImage(systemName: "heart"), for: .normal)
            productFavButton.tintColor = .red
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    
    @IBOutlet weak var pageContoller: UIPageControl!
    
    
    
    @IBAction func productFavBtn(_ sender: UIButton) {
        
        if   (Authorize.isRegistedCustomer())
        {
            productFavButton.isEnabled = false
            
            guard let productIdString = productId, let firstImageURL = firstImageURL else {
                showAlert(message: "The product not loaded yet")
                return
            }
            // i need variant id not product id as draft order deal with it
            if isFav{
                // remove from fav
                let alertController = UIAlertController(title: "Confirmation", message: "Are you sure ? Remove from favorites?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    self.productFavButton.isEnabled = true

                }))

                alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                    guard let self = self else { return }
                    
                    if  CheckNetworkReachability.checkNetworkReachability(){
                    self.productViewModel?.removeFromFavDraftOrders(VariantsId: self.firstVariantId!) { isSuccess in
                        DispatchQueue.main.async {
                            if isSuccess {
                                self.isFav = false
                                self.productFavButton.setImage(UIImage(systemName: "heart"), for: .normal)
                                self.productFavButton.isEnabled = true
                                
                            }
                        }
                    }
                    }else {
                        self.productFavButton.isEnabled = true
                        self.showAlert(message: "Failed to remove from faviourt as lost network connection")
                    }
                }))
                present(alertController, animated: true, completion: nil)
            }
            else{
                // add to fav
//                print("firstVariantId\(firstVariantId)!")
                
                if  CheckNetworkReachability.checkNetworkReachability(){

                productViewModel?.addToFavDraftOrders(selectedVariantsData: [(firstVariantId!, firstImageURL,1)]){ [weak self ] isSuccess in
                    DispatchQueue.main.async {
                        if isSuccess {
                            self?.productFavButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            self?.showCheckMarkAnimation(mark: "heart.fill")
                            self?.isFav = true
                            self?.productFavButton.isEnabled = true
                            
                        } else {
                            self?.showAlert(message: "Sorry,Failed to add to Faviourts" )
                            self?.productFavButton.isEnabled = true
                        }
                    }
                }
                }else {
                 productFavButton.isEnabled = true

                    showAlert(message: "Failed to add from faviourt as lost network connection")
                }
            }}else {
                
                self.showAlertWithTwoOption(message: "Login to add to faviourts?",
                                            okAction: { action in
                    Navigation.ToALogin(from: self)
                    print("OK button tapped")
                }
                )
            }
    }
    
    private func showAlertWithTwoOption(message: String, okAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: okAction)
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction)
        
        alertController.addAction(okAlertAction)
        alertController.addAction(cancelAlertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var addToCard: UIButton!
    
    @IBAction func addCartAction(_ sender: UIButton) {
        if   (Authorize.isRegistedCustomer()){
            
            addToCard.isEnabled = false
            var selectedVariants: [String] = []
            var selectedVariantsIDsAndImageUrl: [(Int ,String,Int)] = []
            
            for subview in stack.arrangedSubviews {
                if let variantStackView = subview as? UIStackView,
                   let variantButton = variantStackView.arrangedSubviews.first as? UIButton,
                   let checkmarkImageView = variantStackView.arrangedSubviews.last as? UIImageView,
                   !checkmarkImageView.isHidden {
                    if let variantText = variantButton.titleLabel?.text {
                        selectedVariants.append(variantText)
                        
                        
                        print("the selectedVariants number = \(selectedVariants.count)")
                        
                        
                        for variant in productViewModel?.product?.variants ?? [] {
                            if let selectedCurrency = settingsViewModel.getSelectedCurrency() {
                                let convertedPrice = settingsViewModel.convertPrice(variant.price, to: selectedCurrency)
                                if( "Size: \(variant.size), Color: \(variant.color ?? "N/A"), Price: \(convertedPrice ?? variant.price)" == variantText){
                                    if let imageUrl = productViewModel?.product?.images.first?.url {
                                        selectedVariantsIDsAndImageUrl.append((id: variant.id, imageUrl: imageUrl,quantity: variant.inventory_quantity! ))
                                    }
                                }
                            } else {
                                if("Size: \(variant.size), Color: \(variant.color ?? "N/A"), Price: \(variant.price)$" == variantText){
                                    if let imageUrl = productViewModel?.product?.images.first?.url {
                                        selectedVariantsIDsAndImageUrl.append((id: variant.id, imageUrl: imageUrl,quantity : variant.inventory_quantity!))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            print("selectedVariantsIDsAndImageUrl number\(selectedVariantsIDsAndImageUrl.count)")
            
            if selectedVariantsIDsAndImageUrl.count == 0 {
                self.showAlert(message: "Please choose your size and color first, then add to card" ){
                               action in
                    self.addToCard.isEnabled = true
                }
            }else {
                    if  CheckNetworkReachability.checkNetworkReachability(){
                    productViewModel?.addToCartDraftOrders(selectedVariantsData:selectedVariantsIDsAndImageUrl) { isSuccess in
                        DispatchQueue.main.async {
                            if isSuccess {
                                self.showCheckMarkAnimation(mark: "cart.fill.badge.plus")
                                self.addToCard.isEnabled = true
                                self.hideAllCheckmarkImages()
                            } else {
                                self.showAlert(message: "Failed to add to cart" )
                                self.addToCard.isEnabled = true
                                //       print("number is not succes")
                            }
                        }
                    }
                }else {
                    showAlert(message: "Failed to add product to cart as lost network connection")
                    addToCard.isEnabled = true

                }
            }
        } else {
                self.showAlertWithTwoOption(message: "Login to add to faviourts?",
                                            okAction: { action in
                    Navigation.ToALogin(from: self)
                }
                )
                
            }
    }
    
    func hideAllCheckmarkImages() {
        for subview in stack.arrangedSubviews {
            if let variantStackView = subview as? UIStackView,
               let checkmarkImageView = variantStackView.arrangedSubviews.last as? UIImageView {
                checkmarkImageView.isHidden = true
            }
        }
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
        
                
        // get it to save product to fav by it
        firstVariantId = variants.first?.id
        
        
        for variant in variants {
            let variantStackView = UIStackView()
            variantStackView.axis = .horizontal
            variantStackView.spacing = 8
            
            
            let variantButton = UIButton(type: .system)
            
            //Handle the currency
            if let selectedCurrency = settingsViewModel.getSelectedCurrency() {
                let convertedPrice = settingsViewModel.convertPrice(variant.price, to: selectedCurrency)
                variantButton.setTitle("Size: \(variant.size), Color: \(variant.color ?? "N/A"), Price: \(convertedPrice ?? variant.price)", for: .normal)
            } else {
                variantButton.setTitle("Size: \(variant.size), Color: \(variant.color ?? "N/A"), Price: \(variant.price)$", for: .normal)
            }
            
            variantButton.setTitleColor(.black, for: .normal)
            variantButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            
            variantButton.addTarget(self, action: #selector(variantButtonTapped(_:)), for: .touchUpInside)
            
            let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmarkImageView.tintColor = .orange
            checkmarkImageView.contentMode = .scaleAspectFit
            checkmarkImageView.isHidden = true
            
            
            // Highlight the selected variant
            if selectedVarientId == variant.id {
                // You can change the background color or add a border to highlight the selected variant
                variantStackView.layer.borderWidth = 2.0
                variantStackView.layer.borderColor = UIColor.orange.cgColor
                variantStackView.layer.cornerRadius = 8.0
            }
            
            
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
    
    private func showAlert(message: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alertController.addAction(okAction)
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
        
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: "ReviewTableViewCell")
        
        var arrayOfReviews = ProductViewModel.getReviews()
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        let review = arrayOfReviews[indexPath.row]
        
        cell.reviewLabel.text = review.1
        cell.reviewerLabel.text = review.0
        cell.cosmosView.rating = review.3
        if let image = UIImage(named: review.2) {
            cell.reviewerImageView.image = image
        } else {
            cell.reviewerImageView.image = UIImage(named: "splash")
        }
        
        return cell
    }
    
}

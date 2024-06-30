//
//  CategoriesViewController.swift
//  Shopify
//
//  Created by Rawan Elsayed on 04/06/2024.
//

import UIKit
import JJFloatingActionButton

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let shoppingCartViewModel = ShoppingCartViewModel()
    
    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let categoriesViewModel = CategoriesViewModel()
    
    var selectedCategory: CategoryId = .men
    var selectedProductType: ProductType = .all
    
    var categoriesCollectionView: UICollectionView!
    var backgroundImageView: UIImageView!
    
    var fabButton: JJFloatingActionButton!
    var additionalFABsVisible = false
    var blurEffectView: UIVisualEffectView?
    var settingsViewModel = SettingsViewModel()
    let homeViewModel = HomeViewModel()
    
    @IBAction func goToAllFav(_ sender: UIBarButtonItem) {
        
        if Authorize.isRegistedCustomer() {
            if homeViewModel.isNetworkReachable() {
                print("go to favss from home")
                Navigation.ToAllFavourite(from: self)
                print("go to favss from home after")
            } else {
                showNoInternetAlert()
            }}else {
                showAlertWithTwoOptionOkayAndCancel(message: "Login to add to favorites?",
                                                    okAction: {  _ in
                    Navigation.ToALogin(from: self)
                    print("Login OK button tapped")
                })
            }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicator.startAnimating()
        
        setupUI()
        setupCartButton()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCategoryProducts(for: selectedCategory, productType: selectedProductType)

        fetchCartItemsAndUpdateBadge()
        fetchExchangeRates()
        checkNetworkConnection()
    }
    
    
    
    func updateCartBadge(itemCount:Int) {
        print("Item count: \(itemCount)")
        if itemCount > 0 {
            cartButton.addBadge(text: "\(itemCount)", color: .orange)
        } else {
            cartButton.removeBadge()
        }
    }
    
    
    private func fetchCartItemsAndUpdateBadge() {
        
        categoriesViewModel.getShoppingCartItemsCount { count, error in
            guard let count = count else {return}
            self.updateCartBadge(itemCount: count - 1)
        }
    }
    

    func setupCartButton() {
        let button = UIButton(type: .custom)
        
        if let cartImage = UIImage(systemName: "cart.fill") {
            print("System cart image loaded successfully")
            let tintedImage = cartImage.withTintColor(.orange, renderingMode: .alwaysOriginal)
            let scaledImage = pondsize(image: tintedImage, size: CGSize(width: 30, height: 25))
            button.setImage(scaledImage, for: .normal)
        } else {
            print("Failed to load system cart image")
        }
        
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(goToCard(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 80)
        cartButton.customView = button
    }
    
    func pondsize(image: UIImage, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return scaledImage
    }
    
    @IBAction func goToCard(_ sender: UIBarButtonItem) {
        if Authorize.isRegistedCustomer() {
            if homeViewModel.isNetworkReachable() {
                Navigation.ToOrders(from: self)
            } else {
                showNoInternetAlert()
            }
        }else {      showAlertWithTwoOptionOkayAndCancel(message: "Login to add to cart?",
                                                         okAction: {  _ in
            Navigation.ToALogin(from: self)
            print("Login OK button tapped")
        })
        }
    }
    
    @IBAction func goToSearch(_ sender: UIBarButtonItem) {
        if homeViewModel.isNetworkReachable() {
            
            let storyboard = UIStoryboard(name: "third", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
                vc.comeFromHome = false
                let searchViewModel = SearchViewModel()
                searchViewModel.recevingProductFromANotherScreen = categoriesViewModel.categoryProducts
                vc.searchViewModel = searchViewModel
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: false, completion: nil)
                
            }
            
        } else {
            showNoInternetAlert()
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedCategory = .men
        case 1:
            selectedCategory = .women
        case 2:
            selectedCategory = .kids
        case 3:
            selectedCategory = .sale
        default:
            break
        }
        // Fetch products for the selected category
        fetchCategoryProducts(for: selectedCategory, productType: selectedProductType)
    }
    
    func setupUI(){
        
        //view.backgroundColor = UIColor(hex: "#F5F5F5")
        let layout = UICollectionViewFlowLayout()
        categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -100).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        categoriesCollectionView.backgroundColor = UIColor.clear
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        categoriesCollectionView.register(CustomCategoriesCell.self, forCellWithReuseIdentifier: "categoriesCell")
        
        // Add background image view
        backgroundImageView = UIImageView(image: UIImage(named: "no_items.jpg"))
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])
        
        fabButton = createFABButton()
        view.addSubview(fabButton)
        fabButton.buttonColor = UIColor(hex: "#FF7D29")
        
        fabButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            fabButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120)
        ])
        updateBackgroundImageViewVisibility()
    }
    
    func updateBackgroundImageViewVisibility() {
        backgroundImageView.isHidden = categoriesViewModel.numberOfCategoryProducts() != 0
    }
    
    func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }
    
    func createAdditionalFABButton(imageName: String, action: @escaping () -> Void) -> JJFloatingActionButton {
        let fab = JJFloatingActionButton()
        fab.buttonImage = UIImage(systemName: imageName)
        fab.buttonColor = UIColor(hex: "#FF7D29")
        fab.addItem { _ in
            action()
            self.hideAdditionalFABs()
        }
        return fab
    }
    
    func createFABButton() -> JJFloatingActionButton {
        let fab = JJFloatingActionButton()
        fab.buttonColor = UIColor(hex: "#FF7D29")
        fab.addItem(title: nil, image: UIImage(systemName: "line.3.horizontal.decrease")) { item in
            self.toggleAdditionalFABs()
        }
        return fab
    }
    
    func showAdditionalFABs() {
        let option1Fab = createAdditionalFABButton(imageName: "arrow.uturn.backward") {
            self.selectedProductType = .all
            self.fetchCategoryProducts(for: self.selectedCategory, productType: self.selectedProductType)
        }
        let option2Fab = createAdditionalFABButton(imageName: "shoe") {
            self.selectedProductType = .shoes
            self.fetchCategoryProducts(for: self.selectedCategory, productType: self.selectedProductType)
        }
        let option3Fab = createAdditionalFABButton(imageName: "tshirt") {
            self.selectedProductType = .t_shirt
            self.fetchCategoryProducts(for: self.selectedCategory, productType: self.selectedProductType)
        }
        let option4Fab = createAdditionalFABButton(imageName: "paperclip") {
            self.selectedProductType = .accessories
            self.fetchCategoryProducts(for: self.selectedCategory, productType: self.selectedProductType)
        }
        
        let option1Label = createLabel(withText: "All")
        let option2Label = createLabel(withText: "Shoes")
        let option3Label = createLabel(withText: "T-Shirt")
        let option4Label = createLabel(withText: "Accessories")
        
        view.addSubview(option1Fab)
        view.addSubview(option2Fab)
        view.addSubview(option3Fab)
        view.addSubview(option4Fab)
        
        view.addSubview(option1Label)
        view.addSubview(option2Label)
        view.addSubview(option3Label)
        view.addSubview(option4Label)
        
        // Adjust the positions of the additional FABs relative to the main FAB button
        option1Fab.translatesAutoresizingMaskIntoConstraints = false
        option2Fab.translatesAutoresizingMaskIntoConstraints = false
        option3Fab.translatesAutoresizingMaskIntoConstraints = false
        option4Fab.translatesAutoresizingMaskIntoConstraints = false
        
        option1Label.translatesAutoresizingMaskIntoConstraints = false
        option2Label.translatesAutoresizingMaskIntoConstraints = false
        option3Label.translatesAutoresizingMaskIntoConstraints = false
        option4Label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            option1Fab.trailingAnchor.constraint(equalTo: fabButton.trailingAnchor),
            option1Fab.bottomAnchor.constraint(equalTo: fabButton.topAnchor, constant: -16),
            option2Fab.trailingAnchor.constraint(equalTo: fabButton.trailingAnchor),
            option2Fab.bottomAnchor.constraint(equalTo: option1Fab.topAnchor, constant: -16),
            option3Fab.trailingAnchor.constraint(equalTo: fabButton.trailingAnchor),
            option3Fab.bottomAnchor.constraint(equalTo: option2Fab.topAnchor, constant: -16),
            option4Fab.trailingAnchor.constraint(equalTo: fabButton.trailingAnchor),
            option4Fab.bottomAnchor.constraint(equalTo: option3Fab.topAnchor, constant: -16),
            
            option1Label.trailingAnchor.constraint(equalTo: option1Fab.leadingAnchor, constant: -8),
            option1Label.centerYAnchor.constraint(equalTo: option1Fab.centerYAnchor),
            option2Label.trailingAnchor.constraint(equalTo: option2Fab.leadingAnchor, constant: -8),
            option2Label.centerYAnchor.constraint(equalTo: option2Fab.centerYAnchor),
            option3Label.trailingAnchor.constraint(equalTo: option3Fab.leadingAnchor, constant: -8),
            option3Label.centerYAnchor.constraint(equalTo: option3Fab.centerYAnchor),
            option4Label.trailingAnchor.constraint(equalTo: option4Fab.leadingAnchor, constant: -8),
            option4Label.centerYAnchor.constraint(equalTo: option4Fab.centerYAnchor)
        ])
        applyBlurEffect()
        additionalFABsVisible = true
    }
    
    func hideAdditionalFABs() {
        for view in view.subviews {
            if let fab = view as? JJFloatingActionButton, fab != fabButton {
                fab.removeFromSuperview()
            }
            if let label = view as? UILabel, label.text != nil {
                label.removeFromSuperview()
            }
        }
        removeBlurEffect()
        additionalFABsVisible = false
    }
    
    func toggleAdditionalFABs() {
        if additionalFABsVisible {
            hideAdditionalFABs()
        } else {
            showAdditionalFABs()
        }
    }
    
    func fetchCategoryProducts(for categoryId: CategoryId , productType: ProductType) {
        categoriesViewModel.fetchCategoryProducts(categoryId , productType) { [weak self] error in
            guard let self = self else { return }
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            if let error = error {
                print("Error fetching category products: \(error)")
            } else {
                self.categoriesCollectionView.reloadData()
                self.updateBackgroundImageViewVisibility()
            }
        }
    }
    
    func fetchAllProducts() {
        categoriesViewModel.fetchAllProducts{ [weak self] error in
            guard let self = self else { return }
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            if let error = error {
                print("Error fetching brands: \(error)")
            } else {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
    
    func fetchExchangeRates(){
        settingsViewModel.fetchExchangeRates { [weak self] error in
            if let error = error {
                print("Error fetching exchange rates: \(error)")
            } else {
                // Reload data once exchange rates are fetched
                self?.categoriesCollectionView.reloadData()
            }
        }
    }
    
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let blurEffectView = blurEffectView {
            // Adjust the alpha of the blur effect view to make it very light
            blurEffectView.alpha = 0.6
            view.insertSubview(blurEffectView, belowSubview: fabButton)
        }
    }
    
    
    func removeBlurEffect() {
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }
    
    private func checkNetworkConnection() {
        if !homeViewModel.isNetworkReachable() {
            showNoInternetAlert()
        }
    }
    
    private func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}


extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomCategoriesCellDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesViewModel.numberOfCategoryProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! CustomCategoriesCell
        
        if let product = categoriesViewModel.product(at: indexPath.item){
            cell.nameCategoriesLabel.text = product.name
            
            if let selectedCurrency = settingsViewModel.getSelectedCurrency(),
               let convertedPrice = settingsViewModel.convertPrice(product.variants.first?.price ?? "N/A", to: selectedCurrency) {
                cell.priceLabel.text = convertedPrice
            } else {
                cell.priceLabel.text = "\(product.variants.first?.price ?? "0") EGP"
            }
            
            if let imageUrlString = product.images.first?.url, let imageUrl = URL(string: imageUrlString) {
                cell.categoriesImgView.kf.setImage(with: imageUrl)
            } else {
                cell.categoriesImgView.image = UIImage(named: "splash-img.jpg")
            }
            
            if product.variants[0].isSelected {
                print("is fav ")
                cell.heartButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            } else {
                print("is not fav")
                cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            cell.heartButton.tag = indexPath.row
            cell.delegate = self
            
        }
        
        return cell
    }
    
    
    func didTapHeartButton(in cell: CustomCategoriesCell) {
        
        var productViewModel = ProductViewModel()
        
        if let indexPath = categoriesCollectionView.indexPath(for: cell) {
            guard let product = categoriesViewModel.product(at: indexPath.row) else {
                return
            }
            
            if Authorize.isRegistedCustomer() {
                cell.heartButton.isEnabled = false
                
                if product.variants[0].id != fakeProductInDraftOrder {
                    // deafult now if false
                    if product.variants[0].isSelected {
                        // Remove from fav
                        showAlertWithTwoOption(message: "Are you sure you want to remove from favorites?",
                                               okAction: { [weak self] _ in
                            print("OK button remove tapped")
                            productViewModel.removeFromFavDraftOrders(VariantsId: product.variants[0].id) { isSuccess in
                                DispatchQueue.main.async {
                                    if isSuccess {
                                        product.variants[0].isSelected = false
                                        cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
                                        cell.heartButton.isEnabled = true
                                        print("remove succeful")
                                    } else {
                                        self?.showAlertWithTwoOption(message: "Failed to remove from favorites")
                                        cell.heartButton.isEnabled = true
                                    }
                                }
                            }
                            
                        }, cancelAction: { _ in
                            cell.heartButton.isEnabled = true
                        }
                        )
                    } else {
                        // Add to fav
                        productViewModel.addToFavDraftOrders(selectedVariantsData: [(product.variants[0].id, product.images.first?.url ?? "", 1)]) { [weak self] isSuccess in
                            DispatchQueue.main.async {
                                if isSuccess {
                                    cell.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                    cell.heartButton.isEnabled = true
                                    print("added succesfully ")
                                    product.variants[0].isSelected = true
                                    self?.showCheckMarkAnimation(mark: "heart.fill")
                                    
                                } else {
                                    self?.showAlertWithTwoOption(message: "Failed to add to favorites")
                                    cell.heartButton.isEnabled = true
                                }
                            }
                        }
                    }}else {
                        showAlert(message: "Sorry ,failed to handle favourite status of this product...check another products")
                        
                    }
            } else {
                showAlertWithTwoOptionOkayAndCancel(message: "Login to add to favorites?",
                                                    okAction: {  _ in
                    Navigation.ToALogin(from: self)
                    print("Login OK button tapped")
                })
            }
        }
    }
    private func showAlert(message: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertWithTwoOption(message: String, okAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: okAction)
        alertController.addAction(okAlertAction)
        
        if let cancelAction = cancelAction {
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction)
            alertController.addAction(cancelAlertAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    private func showAlertWithTwoOptionOkayAndCancel(message: String, okAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: "Okay", style: .default, handler: okAction)
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction)
        
        alertController.addAction(okAlertAction)
        alertController.addAction(cancelAlertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 20 , height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !homeViewModel.isNetworkReachable() {
            showNoInternetAlert()
            return
        }else{
            if let product = categoriesViewModel.product(at: indexPath.row)
            {
                Navigation.ToProduct(productId: "\(product.id)", from: self)
            }
        }
    }
    
}

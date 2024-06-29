import Foundation

class OrderViewModel {
    
    static let shared = OrderViewModel()
    
    var orders: [GetOrder] = []
    var selectedOrder: GetOrder?
    var cartViewModel: ShoppingCartViewModel?
    var addressViewModel: AddressViewModel?
    var settingViewModel: SettingsViewModel?
    var totalPrice: String = ""
    var email = "" {
        didSet {
            print("OrderViewModel email set to: \(email)")
        }
    }
    var customerId = Authorize.getCustomerIDFromUserDefaults()
    
    private init(cartViewModel: ShoppingCartViewModel? = nil, addressViewModel: AddressViewModel? = nil, settingViewModel: SettingsViewModel? = nil) {
        self.cartViewModel = cartViewModel
        self.addressViewModel = addressViewModel
        self.settingViewModel = settingViewModel
    }
    
    func setOrderDetails(totalPrice: String) {
        self.totalPrice = totalPrice
    }
    
    func setEmail(email: String){
        self.email = email
    }
    
    func createOrder(completion: @escaping (ConfirmOrder?, Error?) -> Void) {
        guard let lineItems = cartViewModel?.cartItems.compactMap({ cartItem -> LineItem? in
            let (title, price, quantity, imageUrl, id, quantityInString, variantTitle, productId) = cartItem
            guard id != 45293432635640 else { return nil }
            let properties: [Property] = [
                Property(name: "image_url", value: imageUrl ?? ""),
                Property(name: "quantity_in_string", value: String(quantityInString))
            ]
            return LineItem(id: nil, variant_id: id, product_id: productId, title: title, variant_title: variantTitle, sku: nil, vendor: nil, quantity: quantity, requires_shipping: nil, taxable: nil, gift_card: nil, fulfillment_service: nil, grams: nil, tax_lines: nil, applied_discount: nil, name: nil, custom: nil, price: price.description, admin_graphql_api_id: nil, properties: properties)
        }) else {
            print("Cart items are empty or not initialized")
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cart items are empty"]))
            return
        }
        
        let currency = settingViewModel?.getSelectedCurrency()?.rawValue
        let phone = addressViewModel?.getDefaultAddress()?.phone
        let customer = CustomerOrder(id: Authorize.getCustomerIDFromUserDefaults() ?? 0)
        let gradeTotal = self.fetchGradeTotal()
        let discountTotal = self.fetchTotalDiscount()
        let shippingAddress = DefaultAddress(address1: self.fetchShippingAddress())

        let confirmOrder = ConfirmOrder(
            line_items: lineItems,
            financial_status: "paid",
            currency: "USD",
            phone: phone,
            customer: customer,
            total_discounts: discountTotal,
            current_total_price: gradeTotal,
            total_tax: "5.00",
            created_at: nil,
            shipping_address: shippingAddress
        )
        print("shippingAddress : \(shippingAddress)")
        
        let orderPayload = ["order": confirmOrder]
        
        do {
            let data = try JSONEncoder().encode(orderPayload)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Request Body JSON: \(jsonString)") // Print JSON string for debugging
            }
            NetworkManager.postDataToApi(endpoint: .order, rootOfJson: .order, body: data) { responseData, networkError in
                guard let data = responseData, networkError == nil else {
                    completion(nil, networkError)
                    print("customer.id:  \(customer.id)")
                    print("getCustomerIDFromUserDefaults: \(Authorize.getCustomerIDFromUserDefaults())")
                    return
                }
                print("Response Data: \(String(data: data, encoding: .utf8) ?? "No response data")") // Print raw response data for debugging
                
                do {
                    let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let orderData = responseDict?["order"] {
                        let orderDataJson = try JSONSerialization.data(withJSONObject: orderData)
                        let decodedOrder = try JSONDecoder().decode(ConfirmOrder.self, from: orderDataJson)
                        print ( ": Response Data decodedOrder.line_items\(decodedOrder.line_items?.count)")
                        
                        
                        self.updateVariantQuantityAfterOrder(lineItems: decodedOrder.line_items!)
                        
                        
                        completion(decodedOrder, nil)
                    } else {
                        completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Order data missing in response"]))
                    }
                } catch let decodeError {
                    completion(nil, decodeError)
                }
            }
        } catch let encodeError {
            completion(nil, encodeError)
        }
    }
    
   

    
    func getProductDetails(id: String, completion: @escaping (Product?) -> Void) {
          let addition = "\(id).json"
     print("addition \(addition)")
          NetworkManager.fetchDataFromApi(endpoint: .specificProduct, rootOfJson: .product, addition: addition) { data, error in
              guard let data = data, error == nil else {
                  print("error in data")
                  completion(nil)
                  return
              }

              Decoding.decodeData(data: data, objectType: Product.self) { (product, decodeError) in
                  if let product = product {
                      completion(product)
                  } else {
                      completion(nil)
                  }
              }
          }
      }
    func updateVariantQuantityAfterOrder(lineItems: [LineItem]) {
        print("Response Data in updateVariantQuantityAfterOrder lineItem.count \(lineItems.count)")
        for item in lineItems {
            
            print("Response Data item.variant_id \(item.product_id!) \(item.variant_id!) and item.quantity \(item.quantity!)")
            
            getProductDetails(id: "\(item.product_id!)") { product in
                guard let product = product else { return }
                if let variantIndex = product.variants.firstIndex(where: { $0.id == item.variant_id }) {
                    if let currentQuantity = product.variants[variantIndex].inventory_quantity, let itemQuantity = item.quantity {
                        
                        print("currentQuantity\(currentQuantity) and itemQuantity\(itemQuantity) ")
                        
                        product.variants[variantIndex].inventory_quantity = currentQuantity - itemQuantity
                        
                        print("Response Data new quantity product.variants[\(variantIndex)].inventory_quantity \(product.variants[variantIndex].inventory_quantity!)")
                        
                        self.updateProductDetails(product: product) { success in
                            if success {
  
                                print(" sucess in update")
                                
                            } else {
                                print("Failed to update variant quantity for product id \(item.product_id!)")
                            }
                        }
                    } else {
                        print("Invalid quantity data for variant \(item.variant_id!)")
                    }
                }
            }
        }
    }
    
    func updateProductDetails(product: Product, completion: @escaping (Bool) -> Void) {
        do {
            let productData: [String: Any] = [
                "id": product.id,
                 "variants": product.variants.map {
                    [
                        "id": $0.id,
                        "inventory_quantity": $0.inventory_quantity!
                    ]
                }
            ]
           
            let requestBody: [String: Any] = ["product": productData]
            let data = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Request Body JSON updateProductDetails: \(jsonString)")
            }
            
            let addition = "\(product.id).json"
            print("addition updateProductDetails: \(addition)")
            
            NetworkManager.updateResource(endpoint: .specificProduct, rootOfJson: .product, body: data, addition: addition) { responseData, networkError in
                if let responseData = responseData, networkError == nil {
                    
                    if let jsonResponse = String(data: responseData, encoding: .utf8) {
                        print("Response JSON of updateResource: \(jsonResponse)") // Print response data for debugging
                    }
                    
                    completion(true)
                } else {
                    if let error = networkError {
                        print("Network error: in update \(error)")
                    } else {
                        print("Unknown network error occurred")
                    }
                    
                    completion(false)
                }
            }
        } catch {
            print("Encoding error: \(error)")
            completion(false)
        }
    }
    
    func fetchOrders(completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.fetchDataFromApi(endpoint: .order, rootOfJson: .orders, addition: "?status=any") { responseData, networkError in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            guard let data = responseData else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            Decoding.decodeData(data: data, objectType: [GetOrder].self) { decodedOrders, decodeError in
                if let decodedOrders = decodedOrders {
                    // Filter orders by customer ID
                    self.orders = decodedOrders.filter { $0.customer?.id == Authorize.getCustomerIDFromUserDefaults() }
                    print("order \(self.orders.count)")
                    completion(.success(()))
                } else if let decodeError = decodeError {
                    completion(.failure(decodeError))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode orders"])))
                }
            }
        }
    }
    
    func selectOrder(at index: Int) {
        guard index >= 0 && index < orders.count else { return }
        selectedOrder = orders[index]
    }
    
    func storeGradeTotal(_ gradeTotal: String) {
        UserDefaults.standard.set(gradeTotal, forKey: "gradeTotal")
    }
    
    func fetchGradeTotal() -> String? {
        return UserDefaults.standard.string(forKey: "gradeTotal")
    }
    
    func storeTotalDiscount(_ gradeTotal: String) {
        UserDefaults.standard.set(gradeTotal, forKey: "discountTotal")
    }
    
    func fetchTotalDiscount() -> String? {
        return UserDefaults.standard.string(forKey: "discountTotal")
    }
    
    func storeTotalTax(_ gradeTotal: String) {
        UserDefaults.standard.set(gradeTotal, forKey: "taxTotal")
    }
    
    func fetchTotalTax() -> String? {
        return UserDefaults.standard.string(forKey: "taxTotal")
    }
    
    func storeShippingAddress(_ address: String) {
        UserDefaults.standard.set(address, forKey: "shippingAddress")
    }
    
    func fetchShippingAddress() -> String? {
        return UserDefaults.standard.string(forKey: "shippingAddress")
    }

    
    func sendInvoiceToCustomer(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let draftOrderId = Authorize.cardDraftOrderId()
                //,
              //let customerEmail = Authorize.getCustomeremail()
        else {
            print("Draft Order ID or Customer Email is missing.")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing draft order ID or customer email"])))
            return
        }

        
        let invoiceDetails: [String: Any] = [
            "draft_order_invoice": [
                "to": Authorize.getCustomeremail(),
                "from": "abdosayed20162054@gmail.com",
                "subject": "ShopU Invoice",
                "custom_message": "Thank you for ordering!",
                "bcc": ["abdosayed20162054@gmail.com"]
            ]
        ]
        print("getCustomeremail \(Authorize.getCustomeremail())")
        
        do {
            let body = try JSONSerialization.data(withJSONObject: invoiceDetails, options: [])
            
            let endpoint = "\(draftOrderId)/send_invoice.json"
            
            NetworkManager.postDataToApi(endpoint: .specficDraftOeder, rootOfJson: .sendingInvoice, body: body, addition: endpoint) { data, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }


}


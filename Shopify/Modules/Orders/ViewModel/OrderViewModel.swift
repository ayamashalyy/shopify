//
//  OrderViewModel.swift
//  Shopify
//
//  Created by Rawan Elsayed on 12/06/2024.
//

import Foundation

class OrderViewModel {
    
    static let shared = OrderViewModel()
    
    var orders: [ConfirmOrder] = []
    var selectedOrder: ConfirmOrder?
    var cartViewModel: ShoppingCartViewModel?
    var addressViewModel: AddressViewModel?
    var settingViewModel: SettingsViewModel?
    
    var subtotalPrice: String = ""
    var totalDiscounts: String = ""
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
    
    func setOrderDetails(subtotalPrice: String, totalDiscounts: String, totalPrice: String) {
        self.subtotalPrice = subtotalPrice
        self.totalDiscounts = totalDiscounts
        self.totalPrice = totalPrice
    }
    func setEmail(email: String){
        self.email = email
    }
    
    func createOrder(completion: @escaping (ConfirmOrder?, Error?) -> Void) {
        guard let lineItems = cartViewModel?.cartItems.map({ cartItem -> LineItem in
            let (title, price, quantity, imageUrl, id, quantityInString, variantTitle, productId) = cartItem
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
        
        let shippingAddress = addressViewModel?.getDefaultAddress()
        let currency = settingViewModel?.getSelectedCurrency()?.rawValue
        let phone = addressViewModel?.getDefaultAddress()?.phone
        let customer = CustomerOrder(id: customerId ?? 0)

        let confirmOrder = ConfirmOrder(//email: email,
                                        line_items: lineItems,
                                        financial_status: "paid",
                                       // shipping_address: shippingAddress,
                                        currency: "USD",
                                        phone: phone,
                                        customer: customer,
                                        subtotal_price: subtotalPrice,
                                        total_discounts: totalDiscounts,
                                        total_price: totalPrice,
                                        created_at: nil
        )

        let orderPayload = ["order": confirmOrder]

        do {
            let data = try JSONEncoder().encode(orderPayload)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Request Body JSON: \(jsonString)") // Print JSON string for debugging
            }
            NetworkManager.postDataToApi(endpoint: .order, rootOfJson: .order, body: data) { responseData, networkError in
                guard let data = responseData, networkError == nil else {
                    completion(nil, networkError)
                    return
                }
                print("Response Data: \(String(data: data, encoding: .utf8) ?? "No response data")") // Print raw response data for debugging
                
                do {
                    let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let orderData = responseDict?["order"] {
                        let orderDataJson = try JSONSerialization.data(withJSONObject: orderData)
                        let decodedOrder = try JSONDecoder().decode(ConfirmOrder.self, from: orderDataJson)
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
            
            Decoding.decodeData(data: data, objectType: [ConfirmOrder].self) { decodedOrders, decodeError in
                if let decodedOrders = decodedOrders {
                    //self.orders = decodedOrders
                    // Filter orders by customer ID
                    self.orders = decodedOrders.filter { $0.customer?.id == self.customerId }
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

}


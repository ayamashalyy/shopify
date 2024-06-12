//
//  ProductViewModel.swift
//  Shopify
//
//  Created by mayar on 07/06/2024.
//

import Foundation

class ProductViewModel{
    
        var favViewModel = FavViewModel()
        var bindResultToViewController : (()->()) = {}
        
        var product : Product?{
            didSet{
                bindResultToViewController()
            }
        }
        
            
        func checkIsFav(imageUrl: String, completion: @escaping (Bool) -> Void) {
            favViewModel.bindResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self, let lineItems = self.favViewModel.LineItems else {
                        completion(false)
                        return
                    }
                    
                    let isFav = lineItems.contains { lineItem in
                        imageUrl == lineItem.properties?.first(where: { $0.name == "imageUrl" })?.value
                    }
                    
                    completion(isFav)
                }
            }
            favViewModel.getFavs()
        }
    
    
     func getProductDetails(id: String) {
            
            let addition = "\(id).json"
            NetworkManager.fetchDataFromApi(endpoint: .specificProduct, rootOfJson: .product, addition: addition) { data , error in
                guard let data = data, error == nil else {
                    print("error in data")
                    return
                }
                
                Decoding.decodeData(data: data, objectType: Product.self) { [weak self] (product, decodeError) in
                    guard let self = self else { return }
                    if let product = product {
                        self.product = product
                    }
                }
            }
        }
    
    func addToCartDraftOrders(selectedVariantsData: [(id: Int, imageUrl: String, quantity:Int)], completion: @escaping (Bool) -> Void) {
        getuPdataDraftOrder(selectedVariantsData,isCardIsTrueAndFavIsFAV: true) { draftOrderRequest in
            guard let draftOrderRequest = draftOrderRequest else {
                completion(false)
                return
            }
            
            Decoding.encodeData(object: draftOrderRequest) { jsonData, encodeError in
                guard let jsonData = jsonData, encodeError == nil else {
                    print("Error encoding data:", encodeError?.localizedDescription ?? "Unknown error")
                    completion(false)
                    return
                }
                
                let addition = "\(Authorize.cardDraftOrderId()!).json"
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Request Body JSON: \(jsonString)")
                 }
                
                NetworkManager.updateResource(endpoint: .specficDraftOeder, rootOfJson: .specificDraftOrder, body: jsonData, addition: addition) { data, error in
                    guard let data = data, error == nil else {
                        print("Error fetching customer data:", error?.localizedDescription ?? "Unknown error")
                        completion(false)
                        return
                    }
                    
                    completion(true)
                }
            }
        }
    }

    
    func addToFavDraftOrders(selectedVariantsData: [(id: Int, imageUrl: String, quantity:Int)],completion: @escaping (Bool) -> Void) {
        getuPdataDraftOrder(selectedVariantsData,isCardIsTrueAndFavIsFAV: false) { draftOrderRequest in
            if let draftOrderRequest = draftOrderRequest {
                
                
                Decoding.encodeData(object: draftOrderRequest){ jsonData, encodeError in
                    guard let jsonData = jsonData, encodeError == nil else {
                        print("Error encoding  data:", encodeError?.localizedDescription ?? "Unknown error")
                        completion(false)

                        return
                    }
                    let addition = "\(Authorize.favDraftOrder()!).json"

//                    // Print request details for debugging
                   if let jsonString = String(data: jsonData, encoding: .utf8) {
                       print("Request Body JSON: \(jsonString)")
                    }
                    NetworkManager.updateResource(endpoint: .specficDraftOeder, rootOfJson: .specificDraftOrder, body: jsonData ,addition: addition ){ data , error in
                        guard let data = data, error == nil else {
                            print("Error fetching customer data:", error?.localizedDescription ?? "Unknown error")
                            completion(false)

                            return
                        }
                        completion(true)
                    }
                    
                }
            }
        }
    }
    
    func getuPdataDraftOrder(_ selectedVariantsData: [(id: Int, imageUrl: String, quantity:Int)],isCardIsTrueAndFavIsFAV:Bool, completion: @escaping (DraftOrderRequest?) -> Void) {
        var allLineItems: [LineItem] = []

        // Create LineItem objects from the selected variants data
        for data in selectedVariantsData {
        //    print("Adding to cart with ID: \(data.id) and Image URL: \(data.imageUrl)")
            let lineItem = LineItem(
                id: nil,
                variant_id: data.id,
                product_id: nil,
                title: nil,
                variant_title: nil,
                sku: nil,
                vendor: nil,
                quantity: 1,
                requires_shipping: nil,
                taxable: nil,
                gift_card: nil,
                fulfillment_service: nil,
                grams: nil,
                tax_lines: nil,
                applied_discount: nil,
                name: nil,
                custom: false,
                price: nil,
                admin_graphql_api_id: nil,
                properties: [Property(name: "imageUrl", value: data.imageUrl),Property(name: "quantityInString", value:String(data.quantity))]
            )
            
            allLineItems.append(lineItem)
        }
        let addition : String?
        if isCardIsTrueAndFavIsFAV {
            addition = "\(Authorize.cardDraftOrderId()!).json"
        }else {
            addition =  "\(Authorize.favDraftOrder()!).json"
        }

        NetworkManager.fetchDataFromApi(endpoint: .specficDraftOeder, rootOfJson: .specificDraftOrder, addition: addition) { data, error in
            guard let data = data, error == nil else {
                print("Error in data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            Decoding.decodeData(data: data, objectType: DraftOrder.self) { cardDraftOrder, decodeError in
                guard decodeError == nil else {
                    print("Decoding error: \(decodeError?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                if let lineItems = cardDraftOrder?.line_items {
                    allLineItems.append(contentsOf: lineItems)
                } else {
                    print("No line items found in the fetched data")
                }
                let updatedDraftOrder = self.rearrangeTheDraftOrder(allLineItems: allLineItems, isCardIsTrueAndFavIsFAV: isCardIsTrueAndFavIsFAV)
            //    print("updatedDraftOrder\(updatedDraftOrder)")
                completion(updatedDraftOrder)
            }
        }
    }

    private func rearrangeTheDraftOrder(allLineItems: [LineItem],isCardIsTrueAndFavIsFAV:Bool) -> DraftOrderRequest {
        let customerId = Authorize.getCustomerIDFromUserDefaults()
        let customer = CustomerDraftOrder(
            id: customerId,
            email: nil,
            created_at: nil,
            updated_at: nil,
            first_name: nil,
            last_name: nil,
            orders_count: nil,
            state: nil,
            total_spent: nil,
            last_order_id: nil,
            note: nil,
            verified_email: nil,
            multipass_identifier: nil,
            tax_exempt: nil,
            tags: nil,
            last_order_name: nil,
            currency: nil,
            phone: nil,
            tax_exemptions: [],
            email_marketing_consent: nil,
            smsMarketingConsent: nil,
            admin_graphql_api_id: nil,
            default_address: nil
        )

        let id : Int?
        if isCardIsTrueAndFavIsFAV {
            id = Authorize.cardDraftOrderId()!
        }else {
            id = Authorize.favDraftOrder()!
        }

        let draftOrderDetails = DraftOrder(
            id: id!,
            note: nil,
            email: nil,
            taxes_included: nil,
            currency: nil,
            invoice_sent_at: nil,
            created_at: nil,
            updated_at: nil,
            tax_exempt: nil,
            completed_at: nil,
            name: nil,
            status: nil,
            line_items: allLineItems,
            shipping_address: nil,
            billing_address: nil,
            invoice_url: nil,
            applied_discount: nil,
            order_id: nil,
            shipping_line: nil,
            tax_lines: nil,
            tags: nil,
            note_attributes: [],
            total_price: nil,
            subtotal_price: nil,
            total_tax: nil,
            payment_terms: nil,
            admin_graphql_api_id: nil,
            customer: customer
        )

        return DraftOrderRequest(draft_order: draftOrderDetails)
    }
  
        
  static func getReviews() -> [(String, String, String)] {
                return UserReview.getReviews()
        }

}

//
//  ViewModel.swift
//  Shopify
//
//  Created by mayar on 10/06/2024.
//

import Foundation

class ViewModel {
    
//    func signUp(email: String, firstName: String, lastName: String,  tags: String, completion: @escaping (Bool) -> Void) {
//        
//        // First, create the user and send a verification email
//        AuthenticationManger.createUser(email: email, password: tags) { success, errorMessage in
//            if success {
//                // If user creation and email verification succeed, create the customer
//                let newCustomer = Customer(
//                    email: email,
//                    firstName: firstName,
//                    lastName: lastName,
//                    verifiedEmail: true,
//                    tags: tags,
//                    password: tags,
//                    passwordConfirmation: tags
//                )
//                
//                let customerRequest = CustomerRequest(customer: newCustomer)
//                
//                // Encode the customerRequest
//                Decoding.encodeData(object: customerRequest) { jsonData, encodeError in
//                    guard let jsonData = jsonData, encodeError == nil else {
//                        print("Error encoding customer data:", encodeError?.localizedDescription ?? "Unknown error")
//                        completion(false)
//                        return
//                    }
//                    
//                    NetworkManager.postDataToApi(endpoint: .customers, rootOfJson: .customer, body: jsonData) { data, error in
//                        guard let data = data, error == nil else {
//                            print("Error fetching customer data:", error?.localizedDescription ?? "Unknown error")
//                            completion(false)
//                            return
//                        }
//                        
//                        Decoding.decodeData(data: data, objectType: CustomerResponse.self) { customerResponse, decodeError in
//                            if let customerResponse = customerResponse {
//                                print("New customer created with ID: \(customerResponse.customer.id ?? -1)")
//                                Authorize.saveCustomerIDToUserDefaults(customerID: customerResponse.customer.id! )
//                                self.createTwoDraftOrdersForThisCustomer(customerId: customerResponse.customer.id ?? 0 )
//                                completion(true)
//                            } else {
//                                print("Error decoding customer data:", decodeError?.localizedDescription ?? "Unknown error")
//                                completion(false)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    
    func signUp(email: String, firstName: String, lastName: String, tags: String, completion: @escaping (Bool) -> Void) {
        AuthenticationManger.createUser(email: email, password: tags) { success, errorMessage in
            if success {
                print(" email signUp \(email)")
                self.createCustomer(email: email, firstName: firstName, lastName: lastName, tags: tags) { customerCreationSuccess in
                    completion(customerCreationSuccess)
                }
            } else {
                print("Error creating user:", errorMessage ?? "Unknown error")
                completion(false)
            }
        }
    }
    
    
    func createCustomer(email: String, firstName: String, lastName: String, tags: String, completion: @escaping (Bool) -> Void) {
         let newCustomer = Customer(
             email: email,
             firstName: firstName,
             lastName: lastName,
             verifiedEmail: true,
             tags: tags,
             password: tags,
             passwordConfirmation: tags
         )
         
         let customerRequest = CustomerRequest(customer: newCustomer)
         
         // Encode the customerRequest
         Decoding.encodeData(object: customerRequest) { jsonData, encodeError in
             guard let jsonData = jsonData, encodeError == nil else {
                 print("Error encoding customer data:", encodeError?.localizedDescription ?? "Unknown error")
                 completion(false)
                 return
             }
             
             NetworkManager.postDataToApi(endpoint: .customers, rootOfJson: .customer, body: jsonData) { data, error in
                 guard let data = data, error == nil else {
                     print("Error fetching customer data:", error?.localizedDescription ?? "Unknown error")
                     completion(false)
                     return
                 }
                 
                 Decoding.decodeData(data: data, objectType: CustomerResponse.self) { customerResponse, decodeError in
                     if let customerResponse = customerResponse {
                         print("New customer created with ID: \(customerResponse.customer.id ?? -1)")
                         Authorize.saveCustomerIDToUserDefaults(customerID: customerResponse.customer.id!)
                         self.createTwoDraftOrdersForThisCustomer(customerId: customerResponse.customer.id ?? 0)
                         completion(true)
                     } else {
                         print("Error decoding customer data:", decodeError?.localizedDescription ?? "Unknown error")
                         completion(false)
                     }
                 }
             }
         }
     }
     
    
    
    func createTwoDraftOrdersForThisCustomer(customerId: Int) {
        var firsrtTime = true
        let lineItemProperties1 = [
            Property(name: "imageUrl", value: "fake for only create the draft order"),
            Property(name: "case", value: " fav")
        ]
        let lineItem = LineItem(id: nil, variant_id: 45293446398200, product_id: nil, title: nil, variant_title: nil, sku: nil, vendor: nil, quantity: 1, requires_shipping: nil, taxable: nil, gift_card: nil, fulfillment_service: nil, grams: nil, tax_lines: nil, applied_discount: nil, name: nil, custom: false, price: nil, admin_graphql_api_id: nil, properties: lineItemProperties1)
        
        let customer = CustomerDraftOrder(id: customerId, email: nil, created_at: nil, updated_at: nil, first_name: nil, last_name: nil, orders_count: nil, state: nil, total_spent: nil, last_order_id: nil, note: nil, verified_email: nil, multipass_identifier: nil, tax_exempt: nil, tags: nil, last_order_name: nil, currency: nil, phone: nil, tax_exemptions: [], email_marketing_consent: nil, smsMarketingConsent: nil, admin_graphql_api_id: nil, default_address: nil)
        
        let draftOrderDetails1 = DraftOrder(id: nil, note: nil, email: nil, taxes_included: nil, currency: nil, invoice_sent_at: nil, created_at: nil, updated_at: nil, tax_exempt: nil, completed_at: nil, name: nil, status: nil, line_items: [lineItem], shipping_address: nil, billing_address: nil, invoice_url: nil, applied_discount: nil, order_id: nil, shipping_line: nil, tax_lines: nil, tags:nil, note_attributes: [], total_price: nil, subtotal_price: nil, total_tax: nil, payment_terms: nil, admin_graphql_api_id: nil, customer: customer)
        
        
        
        let lineItemProperties2 = [
            Property(name: "imageUrl", value: "fake for only create the draft order"),
            Property(name: "case", value: " card")
        ]
        let lineItem2 = LineItem(id: nil, variant_id: 45293446398200, product_id: nil, title: nil, variant_title: nil, sku: nil, vendor: nil, quantity: 1, requires_shipping: nil, taxable: nil, gift_card: nil, fulfillment_service: nil, grams: nil, tax_lines: nil, applied_discount: nil, name: nil, custom: false, price: nil, admin_graphql_api_id: nil, properties: lineItemProperties2)
        // the old is bu line item so dave fav
        
        let draftOrderDetails2 = DraftOrder(id: nil, note: nil, email: nil, taxes_included: nil, currency: nil, invoice_sent_at: nil, created_at: nil, updated_at: nil, tax_exempt: nil, completed_at: nil, name: nil, status: nil, line_items: [lineItem2], shipping_address: nil, billing_address: nil, invoice_url: nil, applied_discount: nil, order_id: nil, shipping_line: nil, tax_lines: nil, tags:nil, note_attributes: [], total_price: nil, subtotal_price: nil, total_tax: nil, payment_terms: nil, admin_graphql_api_id: nil, customer: customer)
        
        let draftOrderRequest1 = DraftOrderRequest(draft_order: draftOrderDetails1)
        let draftOrderRequest2 = DraftOrderRequest(draft_order: draftOrderDetails2)
        
        let draftOrders = [draftOrderRequest1, draftOrderRequest2]
        
        for draftOrderRequest in draftOrders {
            print("draftOrderRequest: \(draftOrderRequest)")
            Decoding.encodeData(object: draftOrderRequest) { data, error in
                guard let data = data, error == nil else {
                    print("Failed to encode draft order: \(String(describing: error))")
                    return
                }
                
                NetworkManager.postDataToApi(endpoint: .draftOrder, rootOfJson: .allDraftOrderRoot, body: data) { responseData, responseError in
                    if let responseError = responseError {
                        print("Failed to create draft order: \(responseError)")
                    } else if let responseData = responseData {
                        Decoding.decodeData(data: responseData, objectType: creatingDraftOrderResponse.self) { response, decodeError in
                            if let decodeError = decodeError {
                                //    print("Failed to decode draft order response: \(decodeError)")
                            } else if let response = response {
                                
                                let draftOrderID = response.draft_order.id
                                if firsrtTime {
                                    // first is fav
                                    Authorize.favDraftOrder(draftOrderIDOne: draftOrderID!)
                                    firsrtTime = false
                                }else{
                                    Authorize.cardDraftOrderId(draftOrderIDTwo: draftOrderID!)
                                }
                            } else {
                                print("Received empty response data.")
                            }
                        }
                    } else {
                        print("Received no response data and no error.")
                    }
                }
            }
        }
    }
}

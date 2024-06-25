//
//  ShoppingCartViewModel.swift
//  Shopify
//
//  Created by aya on 03/06/2024.
//

import Foundation

class ShoppingCartViewModel {
    var orderViewModel = OrderViewModel.shared

    
    var cartItems = [(String, Int, Int, String?, Int, Int, String, Int)]()
    var updateCartItemsHandler: (() -> Void)?
    var productViewModel = ProductViewModel()
    var draftOrders: DraftOrder?
    func fetchDraftOrders(completion: @escaping (Error?) -> Void) {
        let additionDraftOrder = "\(Authorize.cardDraftOrderId()!).json"
        
        NetworkManager.fetchDataFromApi(endpoint: .specficDraftOeder, rootOfJson: .specificDraftOrder, addition: additionDraftOrder) { (data, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }
            
            do {
                print("Received data: \(String(data: data, encoding: .utf8) ?? "No data")")
                let draftOrders = try JSONDecoder().decode(DraftOrder.self, from: data)
                self.draftOrders = draftOrders
                self.updateCartItems(with: draftOrders)
                completion(nil)
            } catch let decodingError {
                completion(decodingError)
            }
        }
    }
    
    func updateCartItems(with draftOrders: DraftOrder) {
        guard let lineItems = draftOrders.line_items else {
            return
        }
        
        for index in 0..<lineItems.count {
            let lineItem = lineItems[index]
            let id = lineItem.variant_id ?? 0
            let productId = lineItem.product_id ?? 0
            print("id\(id)")
            let title = lineItem.title ?? "Unknown"
            let quantity = lineItem.quantity ?? 0
            let price = lineItem.price ?? "0.00"
            let priceFloat = Float(price) ?? 0.0
            let priceInt = Int(priceFloat)
            let variant_title = lineItem.variant_title ?? "Unknown"
            let imageUrl = lineItem.properties?.first(where: { $0.name == "imageUrl" })?.value
            let quantityInString = Int(lineItem.properties?.first(where: { $0.name == "quantityInString" })?.value ?? "0") ?? 0
            
            if let index = cartItems.firstIndex(where: { $0.4 == id }) {
                cartItems[index].2 += quantity
            } else {
                print("productId: \(productId), Item ID: \(id), Title: \(title), Quantity: \(quantity), Price: \(priceInt), Variant Title: \(variant_title), Image URL: \(imageUrl ?? "No Image URL")")
                
                cartItems.append((title, priceInt, quantity, imageUrl, id, quantityInString, variant_title, productId))
            }
        }
        updateCartItemsHandler?()
    }
    
    func updateItemQuantity(itemId: Int, newQuantity: Int, completion: @escaping (Error?) -> Void) {
        guard let itemIndex = cartItems.firstIndex(where: { $0.4 == itemId }) else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Item not found"]))
            return
        }
        
        cartItems[itemIndex].2 = newQuantity
        print("updateItemQuantity\(newQuantity)")
        updateDraftOrder(with: cartItems,variantId: itemId,newQuantity: newQuantity) { error in
            
            if let error = error {
                completion(error)
            } else {
                self.updateCartItemsHandler?()
                completion(nil)
            }
        }
    }
    
    func updateDraftOrder(with cartItems: [(String, Int, Int, String?, Int, Int, String, Int)], variantId: Int, newQuantity: Int, completion: @escaping (Error?) -> Void) {
        let updateEndpoint = Endpoint.specficDraftOeder
        let rootOfJson = Root.specificDraftOrder
        let draftOrderId = "\(Authorize.cardDraftOrderId()!).json"
        var lineItemsDict: [[String: Any]] = []
        
        for item in cartItems {
            var properties: [[String: Any]] = []
            
            if let imageUrl = item.3 {
                properties.append([
                    "name": "imageUrl",
                    "value": imageUrl
                ])
            }
            properties.append([
                "name": "quantityInString",
                "value": String(item.5)
            ])
            print("quantity item ..........................")
            print("quantity item \(item.5)")
            if item.4 == variantId {
                lineItemsDict.append([
                    "variant_id": variantId,
                    "quantity": newQuantity,
                    "properties": properties
                ])
            } else {
                lineItemsDict.append([
                    "variant_id": item.4,
                    "quantity": item.2,
                    "properties": properties
                ])
            }
        }
        
        let body: [String: Any] = [
            "draft_order": [
                "id": Authorize.cardDraftOrderId()!,
                "line_items": lineItemsDict
            ]
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON"]))
            return
        }
        if let jsonString = String(data: bodyData, encoding: .utf8) {
            print("Request Body JSON: \(jsonString)")
        }
        
        NetworkManager.updateResource(endpoint: updateEndpoint, rootOfJson: rootOfJson, body: bodyData, addition: draftOrderId) { (data, error) in
            completion(error)
        }
    }
    
    func deleteLineItem (with cartItems: [(String, Int, Int, String?, Int, Int, String, Int)],variantId: Int,newQuantity: Int, completion: @escaping (Error?) -> Void) {
        let updateEndpoint = Endpoint.specficDraftOeder
        let rootOfJson = Root.specificDraftOrder
        let draftOrderId = "\(Authorize.cardDraftOrderId()!).json"
        var lineItemsDict: [[String: Any]] = []
        
        for item in cartItems {
            var properties: [[String: Any]] = []
            
            if let imageUrl = item.3 {
                properties.append([
                    "name": "imageUrl",
                    "value": imageUrl
                ])
            }
            properties.append([
                "name": "quantityInString",
                "value": String(item.5)
            ])
            
            if item.4 == variantId
            {
                
            }
            else
            {
                lineItemsDict.append([
                    "variant_id": item.4,
                    "quantity": item.2,
                    "properties": properties
                ])
            }
        }
        
        
        let body: [String: Any] = [
            "draft_order": [
                "id": Authorize.cardDraftOrderId()!,
                "line_items": lineItemsDict
            ]
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON"]))
            return
        }
        if let jsonString = String(data: bodyData, encoding: .utf8) {
            print("Request Body JSON: \(jsonString)")
        }
        NetworkManager.updateResource(endpoint: updateEndpoint, rootOfJson: rootOfJson, body: bodyData, addition: draftOrderId) { (data, error) in
            completion(error)
        }
    }
    
    
    func deleteLineItems(completion: @escaping (Error?) -> Void) {
        fetchDraftOrders { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            }
            
            guard let draftOrders = self.draftOrders else {
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No draft order found"]))
                return
            }
            
            let updateEndpoint = Endpoint.specficDraftOeder
            let rootOfJson = Root.specificDraftOrder
            let draftOrderId = "\(Authorize.cardDraftOrderId()!).json"
            var lineItemsDict: [[String: Any]] = []
            
            for lineItem in draftOrders.line_items ?? [] {
                var properties: [[String: Any]] = []
                
                if let imageUrl = lineItem.properties?.first(where: { $0.name == "imageUrl" })?.value {
                    properties.append([
                        "name": "imageUrl",
                        "value": imageUrl
                    ])
                }
                properties.append([
                    "name": "quantityInString",
                    "value": String(lineItem.properties?.first(where: { $0.name == "quantityInString" })?.value ?? "0")
                ])
                
                if lineItem.variant_id == 45293432635640
                      {
                    lineItemsDict.append([
                        "variant_id": lineItem.variant_id ?? 0,
                        "quantity": lineItem.quantity ?? 0,
                        "properties": properties
                    ])
                }
            }
            
            let body: [String: Any] = [
                "draft_order": [
                    "id": Authorize.cardDraftOrderId()!,
                    "line_items": lineItemsDict
                ]
            ]
            
            guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON"]))
                return
            }
            
            if let jsonString = String(data: bodyData, encoding: .utf8) {
                print("Request Body JSON: \(jsonString)")
            }
            
            NetworkManager.updateResource(endpoint: updateEndpoint, rootOfJson: rootOfJson, body: bodyData, addition: draftOrderId) { (data, error) in
                completion(error)
            }
        }
    }
    
    func updateDraftOrderAfterOrder(completion: @escaping (Error?) -> Void) {
        fetchDraftOrders { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            }
            
            guard let draftOrders = self.draftOrders else {
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No draft order found"]))
                return
            }
            
            let (lineItemsDictHaveDefaultOnly, lineItemsDictAcutllalyOrderOnly) = self.separateLineItems(draftOrders: draftOrders)
            
            self.updateDraftOrder(lineItems: lineItemsDictAcutllalyOrderOnly) { error in
                if let error = error {
                    completion(error)
                    return
                }
                print(" make with actually done fffff")
                self.sendInvoiceAndReupdate(lineItemsDictHaveDefaultOnly: lineItemsDictHaveDefaultOnly, completion: completion)
            }
        }
    }

    private func separateLineItems(draftOrders: DraftOrder) -> ([[String: Any]], [[String: Any]]) {
        var lineItemsDictHaveDefaultOnly: [[String: Any]] = []
        var lineItemsDictAcutllalyOrderOnly: [[String: Any]] = []
        
        for lineItem in draftOrders.line_items ?? [] {
            var properties: [[String: Any]] = []
            
            if let imageUrl = lineItem.properties?.first(where: { $0.name == "imageUrl" })?.value {
                properties.append([
                    "name": "imageUrl",
                    "value": imageUrl
                ])
            }
            properties.append([
                "name": "quantityInString",
                "value": String(lineItem.properties?.first(where: { $0.name == "quantityInString" })?.value ?? "0")
            ])
            
            if lineItem.variant_id == 45293432635640 {
                lineItemsDictHaveDefaultOnly.append([
                    "variant_id": lineItem.variant_id ?? 0,
                    "quantity": lineItem.quantity ?? 0,
                    "properties": properties
                ])
            } else {
                lineItemsDictAcutllalyOrderOnly.append([
                    "variant_id": lineItem.variant_id ?? 0,
                    "quantity": lineItem.quantity ?? 0,
                    "properties": properties
                ])
            }
        }
        
        return (lineItemsDictHaveDefaultOnly, lineItemsDictAcutllalyOrderOnly)
    }

    private func updateDraftOrder(lineItems: [[String: Any]], completion: @escaping (Error?) -> Void) {
        let updateEndpoint = Endpoint.specficDraftOeder
        let rootOfJson = Root.specificDraftOrder
        let draftOrderId = "\(Authorize.cardDraftOrderId()!).json"
        
        let body: [String: Any] = [
            "draft_order": [
                "id": Authorize.cardDraftOrderId()!,
                "line_items": lineItems
            ]
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON"]))
            return
        }
        NetworkManager.updateResource(endpoint: updateEndpoint, rootOfJson: rootOfJson, body: bodyData, addition: draftOrderId) { (data, error) in
            completion(error)
        }
    }

    
    private func sendInvoiceAndReupdate(lineItemsDictHaveDefaultOnly: [[String: Any]], completion: @escaping (Error?) -> Void) {
        self.orderViewModel.sendInvoiceToCustomer { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success():
                print(" Invoice sent successfully fffff")

                self.updateDraftOrder(lineItems: lineItemsDictHaveDefaultOnly) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    print("Re-update with default one fffff")
                    completion(nil)
                }
            case .failure(let error):
                print("Failed to send invoice: \(error.localizedDescription)")
                completion(error)
            }
        }
    }    
    
    
    func getShoppingCartItemsCount(completion: @escaping (Int?, Error?) -> Void)
    {
        GetShoppingCartItemsCount.getShoppingCartItemsCount(completion: completion)
    }

}

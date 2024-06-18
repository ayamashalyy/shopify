import Foundation

class ShoppingCartViewModel {
    var cartItems = [(String, Int, Int, String?, Int, Int, String, Int)]()
    var updateCartItemsHandler: (() -> Void)?
    var productViewModel = ProductViewModel()
    
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
        
        for index in 0..<lineItems.count  {
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
    
    
}

import Foundation

class ShoppingCartViewModel {
    var cartItems = [(String, Int, Int, String?)]()
    var updateCartItemsHandler: (() -> Void)?
    var productViewModel = ProductViewModel()
    

    func fetchDraftOrders(completion: @escaping (Error?) -> Void) {
        let additionDraftOrder = "1184699220216.json"
        
        NetworkManager.fetchDataFromApi(endpoint: .draftOrder, rootOfJson: .draftOrderRoot, addition: additionDraftOrder) { (data, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }
            
            do {
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
        
        for lineItem in lineItems {
            let title = lineItem.title ?? "Unknown"
            let quantity = lineItem.quantity ?? 0
            let price = lineItem.price ?? "0.00"
            let priceFloat = Float(price) ?? 0.0
            let priceInt = Int(priceFloat)
            
            if let index = cartItems.firstIndex(where: { $0.0 == title }) {
                cartItems[index].2 += quantity
            } else {
                cartItems.append((title, priceInt, quantity, nil))
            }
        }
        updateCartItemsHandler?()
    }
    
 
}

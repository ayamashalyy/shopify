//
//  FavViewModel.swift
//  Shopify
//
//  Created by mayar on 11/06/2024.
//

import Foundation

class FavViewModel {
    
    var bindResultToViewController : (()->()) = {}
    
    var LineItems : [LineItem]?{
        didSet{
            print("did set line item \(LineItems?[0].title)")
            print("did set line item \(LineItems?[1].title)")

            bindResultToViewController()
         //   print("LineItems     is    \(LineItems?.count)")
        }
    }
    
    func getFavs() {
        let addition = "\(Authorize.favDraftOrder()!).json"
        // for testin the get and show but real should be the above
       //let addition = "1184814104824.json"
        
      //  print( "additon in fav Authorize.favDraftOrder \(addition)")

        NetworkManager.fetchDataFromApi(endpoint: .specficDraftOeder, rootOfJson: .specificDraftOrder, addition: addition) { data , error in
            guard let data = data, error == nil else {
                print("error in data")
                return
            }
            
            Decoding.decodeData(data: data, objectType: DraftOrder.self) { [weak self] (draftOrder, decodeError) in
                guard let self = self else { return }
                if let draftOrder = draftOrder {
                    self.LineItems = draftOrder.line_items

                }
            }
        }
    }
    
    
    func removeLineItem(index:Int){
        print("index is \(index)")
        
        
        
    }

    
    
    
}

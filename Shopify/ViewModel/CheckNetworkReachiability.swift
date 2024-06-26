//
//  CheckNetworkReachiability.swift
//  Shopify
//
//  Created by mayar on 21/06/2024.
//
import Foundation
import Reachability

class CheckNetworkReachability {

    static func checkNetworkReachability() -> Bool {
        var thereIsNetwork = false
        
        do {
            let reachability = try Reachability()
            
            switch reachability.connection {
            case .wifi, .cellular:
                thereIsNetwork = true
                print(" there are network")
            case .unavailable, .none:
                thereIsNetwork = false
                print("no network")
            }
        } catch {
            print("Unable to create Reachability instance: \(error.localizedDescription)")
        }
        
        return thereIsNetwork
    }
}

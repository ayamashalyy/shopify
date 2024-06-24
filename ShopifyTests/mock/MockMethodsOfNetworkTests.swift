//
//  MockMethodsOfNetworkTests.swift
//  ShopifyTests
//
//  Created by mayar on 24/06/2024.
//

import XCTest

@testable import Shopify

final class MockMethodsOfNetworkTests: XCTestCase {
    
    var mockNetworkManager: MockNetworkManager!

    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager(networkConnection: false)
    }

    override func tearDownWithError() throws {
        mockNetworkManager = nil
    }

    
    func testFetchProductDetailsSuccess() {
        let addition = "8575848153336.json"
        mockNetworkManager.fetchDataFromApi(endpoint: .specificProduct, rootOfJson: .product, addition: addition) { data, error in
                XCTAssertNotNil(data, "Data should not be nil")
                do {
                    let productResponse = try JSONDecoder().decode(Product.self, from: data!)
                    XCTAssertEqual(productResponse.name, "ADIDAS | CLASSIC BACKPACK")
                } catch {
                    print("erorr in decooding")
                }
        }
       
    }

    func testFetchProductDetailsFailure() {
        let expectation = self.expectation(description: "Wait for API response")
        
        // Simulate a network failure
        mockNetworkManager.networkConnection = true
        
        let addition = "8575848153336.json"
        mockNetworkManager.fetchDataFromApi(endpoint: .specificProduct, rootOfJson: .product, addition: addition) { data, error in
            if let error = error {
                XCTAssertNil(data, "Data should be nil when there is an error")
                XCTAssertNotNil(error, "Error should not be nil")
                expectation.fulfill()
            } else {
                XCTFail("Expected to fail, but succeeded with data: \(String(describing: data))")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

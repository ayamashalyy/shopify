//
//  MethodsOfNetwork.swift
//  ShopifyTests
//
//  Created by mayar on 24/06/2024.
//

import XCTest
@testable import Shopify

final class MethodsOfNetwork: XCTestCase {
    
    
    var networkService : NetworkManager?
    
    override func setUpWithError() throws {
        //  networkService = NetworkManager()
    }
    
    override func tearDownWithError() throws {
        //  networkService = nil
    }
    
    
    
    func testFetchMethod() {
        let expectation = self.expectation(description: "Wait for API response")
        
        let addition = "8575848153336.json"
        NetworkManager.fetchDataFromApi(endpoint: .specificProduct, rootOfJson: .product, addition: addition) { data, error in
            if let error = error {
                XCTFail("API request failed with error: \(error)")
            } else {
                XCTAssertNotNil(data, "Data should not be nil")
                do {
                    let product = try JSONDecoder().decode(Product.self, from: data!)
                    XCTAssertEqual(product.name, "ADIDAS | CLASSIC BACKPACK")
                    expectation.fulfill()
                } catch {
                    XCTFail("Decoding failed with error: \(error)")
                }
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchFailure() {
        let expectation = self.expectation(description: "Wait for API response")
        
        let invalidAddition = "invalid.json"
        NetworkManager.fetchDataFromApi(endpoint: .specificProduct, rootOfJson: .product, addition: invalidAddition) { data, error in
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
    
    func testPostDataSuccess() {
        var number = 6
        let expectation = self.expectation(description: "Wait for API response")
        
        let newCustomer = Customer(
            email: "test\(number)@example.com",
            firstName: "testFirstName",
            lastName: "testlastName",
            verifiedEmail: true,
            tags: "123456",
            password: "123456",
            passwordConfirmation: "123456"
        )
        
        let customerRequest = CustomerRequest(customer: newCustomer)
        
        do {
            let jsonData = try JSONEncoder().encode(customerRequest)
            
            NetworkManager.postDataToApi(endpoint: .customers, rootOfJson: .customer, body: jsonData) { data, error in
                if let error = error {
                    XCTFail("API request failed with error: \(error)")
                } else { // the return of response
                    XCTAssertNotNil(data, "Data should not be nil")
                    do {
                        number += 1
                        // Assuming the data is being decoded to a CustomerResponse object
                        let customerResponse = try JSONDecoder().decode(CustomerResponse.self, from: data!)
                        XCTAssertEqual(customerResponse.customer.email, newCustomer.email)
                        expectation.fulfill()
                    } catch {
                        XCTFail("Decoding failed with error: \(error)")
                    }
                }
            }
        } catch {
            XCTFail("Encoding failed with error: \(error)")
        }
        
        waitForExpectations(timeout: 10)
    }
    
//    func testPostDataFailure() {
//        let expectation = self.expectation(description: "Wait for API response")
//        
//        let newCustomer = Customer(
//            email: "testDataFailure@example.com",
//            firstName: "testFirstName",
//            lastName: "testlastName",
//            verifiedEmail: true,
//            tags: "123456",
//            password: "123456",
//            passwordConfirmation: "123456"
//        )
//        
//        let customerRequest = CustomerRequest(customer: newCustomer)
//        
//        do {
//            let jsonData = try JSONEncoder().encode(customerRequest)
//            
//            // Use an invalid endpoint or modify the request to simulate a failure
//            NetworkManager.postDataToApi(endpoint: .invalidEndpoint, rootOfJson: .customer, body: jsonData) { data, error in
//                if let error = error {
//                    XCTAssertNil(data, "Data should be nil when there is an error")
//                    XCTAssertNotNil(error, "Error should not be nil")
//                    expectation.fulfill()
//                } else {
//                    XCTFail("Expected to fail, but succeeded with data: \(String(describing: data))")
//                }
//            }
//        } catch {
//            XCTFail("Encoding failed with error: \(error)")
//        }
//        waitForExpectations(timeout: 10)
//    }
}

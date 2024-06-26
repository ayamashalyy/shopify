//
//  APIError.swift
//  Shopify
//
//  Created by aya on 08/06/2024.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidData
    case networkError(Error)
    case serverError(statusCode: Int, data: Data?)
    case unknownError
    
    var description: String {
        switch self {
        case .invalidResponse:
            return "Invalid response from API"
        case .invalidData:
            return "Invalid data received from API"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let statusCode, let data):
            let dataString = data.flatMap { String(data: $0, encoding: .utf8) } ?? "No data"
            return "Server error with status code \(statusCode): \(dataString)"
        case .unknownError:
            return "Unknown error occurred"
        }
    }
}

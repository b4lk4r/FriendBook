//
//  NetworkError.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Alamofire

enum NetworkError: Error {
    case alamofireError(AFError)
    case invalidResponse
    case custom(String)
    case unauthorized
    case serverError(Int)
    case encodingFailed
    
    var localizedDescription: String {
        switch self {
        case .alamofireError(let error): return "Network error: \(error.localizedDescription)"
        case .invalidResponse: return "Invalid server response"
        case .custom(let message): return message
        case .unauthorized: return "Authentication required"
        case .serverError(let code): return "Server error (\(code))"
        case .encodingFailed: return "Encoding failed"
        }
    }
}

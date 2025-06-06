//
//  GeminiServiceError.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 03.06.2025.
//

enum GeminiServiceError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case keychainError
}

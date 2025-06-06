//
//  GigaChatServiceError.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

enum GigaChatServiceError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case authFailed
    case keychainError
}

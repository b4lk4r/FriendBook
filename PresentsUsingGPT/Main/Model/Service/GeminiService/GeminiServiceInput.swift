//
//  GeminiServiceInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Foundation

protocol GeminiServiceInput {
    func sendPrompt(_ prompt: String, completion: @escaping (Result<String, GeminiServiceError>) -> Void)
}

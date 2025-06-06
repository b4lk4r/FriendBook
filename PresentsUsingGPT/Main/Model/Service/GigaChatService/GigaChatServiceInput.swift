//
//  GigaChatServiceInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Foundation

protocol GigaChatServiceInput {
    func sendPrompt(_ prompt: String, completion: @escaping (Result<String, GigaChatServiceError>) -> Void)
}

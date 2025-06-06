//
//  GigaChatCompletionRequest.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

struct ChatCompletionRequest: Encodable {
    let model: String
    let messages: [Message]
    
    struct Message: Encodable {
        let role: String
        let content: String
    }
}

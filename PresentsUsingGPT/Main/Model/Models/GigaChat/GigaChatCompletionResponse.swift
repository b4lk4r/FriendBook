//
//  GigaChatCompletionResponse.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

struct ChatCompletionResponse: Decodable {
    let choices: [Choice]
    
    struct Choice: Decodable {
        let message: Message
        
        struct Message: Decodable {
            let content: String
        }
    }
}

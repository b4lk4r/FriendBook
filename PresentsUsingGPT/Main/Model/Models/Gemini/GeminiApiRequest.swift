//
//  GeminiApiRequest.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 03.06.2025.
//

import Foundation

struct GeminiApiRequest: Encodable {
    let contents: [ContentBlock]
    
    struct ContentBlock: Encodable {
        let parts: [Part]
        
        struct Part: Encodable {
            let text: String
        }
    }
}

//
//  GeminiApiResponse.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 03.06.2025.
//

import Foundation

struct GeminiApiResponse: Decodable {
    let candidates: [Candidate]
    
    struct Candidate: Decodable {
        let content: Content
        
        struct Content: Decodable {
            let parts: [Part]
            
            struct Part: Decodable {
                let text: String
            }
        }
    }
}

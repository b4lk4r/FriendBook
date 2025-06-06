//
//  AuthResponse.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Foundation

struct AuthResponse: Decodable {
    let accessToken: String
    let expiresAt: Int64
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresAt = "expires_at"
    }
}

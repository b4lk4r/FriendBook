//
//  KeyChainManagerInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

protocol KeychainManagerInput {
    func save(_ value: String, forKey key: String) -> Bool
    func get(forKey key: String) -> String?
    func delete(forKey key: String) -> Bool
}

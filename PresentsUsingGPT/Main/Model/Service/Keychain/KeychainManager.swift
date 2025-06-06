//
//  KeychainManager.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//
import Foundation
import KeychainSwift

final class KeychainManager: KeychainManagerInput {
    
    // MARK: Private properties
    
    private let keychain = KeychainSwift()
    
    // MARK: Internal functions
    
    func save(_ value: String, forKey key: String) -> Bool {
        keychain.set(value, forKey: key)
    }
    
    func get(forKey key: String) -> String? {
        keychain.get(key)
    }
    
    func delete(forKey key: String) -> Bool {
        keychain.delete(key)
    }
}

//
//  ChatViewControllerInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

protocol ChatViewControllerInput: AnyObject {
    func configure(with friend: Friend, aiName: String)
    func addMessage(_ text: String, isFromUser: Bool)
    func showError(_ error: String)
}

//
//  ChatViewControllerPresenterInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

protocol ChatViewControllerPresenterInput: AnyObject {
    var view: ChatViewControllerInput? { get set }
    
    func configure(with friend: Friend?, aiName: String)
    func currentFriend() -> Friend?
    func currentAIName() -> String?
    func setAIName(name: String)
    func sendPrompt(_ prompt: String)
}

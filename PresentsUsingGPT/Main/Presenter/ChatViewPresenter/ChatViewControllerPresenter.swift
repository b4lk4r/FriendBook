//
//  ChatViewControllerPresenter.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//
import Foundation

final class ChatViewControllerPresenter: ChatViewControllerPresenterInput {
    
    // MARK: Private properties
    
    weak var view: ChatViewControllerInput?
    
    private let gigaChatService: GigaChatServiceInput
    private let geminiService: GeminiServiceInput
    
    private var friend: Friend?
    private var aiName: String = "GigaChat"
    
    // MARK: Init
    
    init(gigaChatService: GigaChatServiceInput, geminiService: GeminiServiceInput) {
        self.gigaChatService = gigaChatService
        self.geminiService = geminiService
    }
    
    // MARK: Internal functions
    
    func configure(with friend: Friend?, aiName: String) {
        self.friend = friend
        self.aiName = aiName
    }
    
    func currentFriend() -> Friend? {
        friend
    }
    
    func currentAIName() -> String? {
        aiName
    }
    
    func setAIName(name: String) {
        self.aiName = name
    }
    
    func sendPrompt(_ prompt: String) {
        if aiName == "GigaChat" {
            gigaChatService.sendPrompt(prompt) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.view?.addMessage(response, isFromUser: false)
                    case .failure(let error):
                        self?.view?.showError(error.localizedDescription)
                    }
                }
            }
        }
        else {
            geminiService.sendPrompt(prompt) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.view?.addMessage(response, isFromUser: false)
                    case .failure(let error):
                        self?.view?.showError(error.localizedDescription)
                    }
                }
            }
        }
    }
}

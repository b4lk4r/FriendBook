//
//  Зкуыутеук.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Foundation

final class Presenter: PresenterInput {
    
    // MARK: Internal properties
    
    weak var view: ViewControllerInput?
    
    // MARK: Private properties
    
    private let gigaChatService: GigaChatServiceInput
    private let geminiService: GeminiServiceInput
    
    // MARK: Init
    
    init(gigaChatService: GigaChatServiceInput, geminiService: GeminiServiceInput) {
        self.gigaChatService = gigaChatService
        self.geminiService = geminiService
    }
    
    // MARK: Internal functions
    
    func sendPrompt(_ prompt: String) {
//        gigaChatService.sendPrompt(prompt) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    
//                    self?.view?.showResponse(response)
//                case .failure(let error):
//                    self?.view?.showError(error.localizedDescription)
//                }
//            }
//        }
        
        geminiService.sendPrompt(prompt) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    
                    self?.view?.showResponse(response)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}

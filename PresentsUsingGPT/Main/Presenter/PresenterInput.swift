//
//  PresenterInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

protocol PresenterInput {
    
    var view: ViewControllerInput? { get set }
    
    func sendPrompt(_ prompt: String)
}

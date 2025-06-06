//
//  MainTabBarControllerInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

protocol MainTabBarControllerInput: AnyObject {
    func openChat(with friend: Friend, aiName: String)
}

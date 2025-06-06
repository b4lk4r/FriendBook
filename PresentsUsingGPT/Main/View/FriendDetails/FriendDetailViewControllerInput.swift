//
//  FriendDetailViewControllerInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

protocol FriendDetailViewControllerInput: AnyObject {
    func updateUI(friend: Friend)
    func showError(message: String)
}

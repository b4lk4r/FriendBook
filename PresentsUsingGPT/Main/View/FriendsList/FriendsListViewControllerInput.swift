//
//  FriendsListViewControllerInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

protocol FriendsListViewControllerInput: AnyObject {
    func reloadData()
    func updateTitle(_ title: String)
    func showError(_ message: String)
}

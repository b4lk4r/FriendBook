//
//  FriendDetailPresenterInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

protocol FriendDetailPresenterInput: AnyObject {
    var view: FriendDetailViewControllerInput? { get set }
    
    func loadFriend()
    func editFriend()
    func handleFriendEdited(friend: Friend)
    func deleteFriend()
    func handleGiftButtonTapped()
    func getFriendIndex() -> Int
    func getFriend() -> Friend
}

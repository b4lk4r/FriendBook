//
//  FriendsListPresenterInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

protocol FriendsListPresenterInput: AnyObject {
    var view: FriendsListViewControllerInput? { get set }
    
    func numberOfFriends() -> Int
    func friend(at index: Int) -> Friend?
    func addFriend(_ friend: Friend)
    func updateFriend(_ friend: Friend, at index: Int)
    func deleteFriend(at index: Int)
}

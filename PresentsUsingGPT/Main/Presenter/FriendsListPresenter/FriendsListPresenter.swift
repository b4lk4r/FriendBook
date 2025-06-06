//
//  FriendsListPresenter.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

import Foundation

final class FriendsListPresenter {
    
    // MARK: Private properties
    
    weak var view: FriendsListViewControllerInput?
    private var friends: [Friend] = []
    
    // MARK: Init
    
    init() {
        loadFriends()
        subscribeToNotifications()
    }
    
    // MARK: Private functions
    
    private func loadFriends() {
        // Загрузка из хранилища, например
        self.friends = FriendsDataManager.shared.getFriends()
        view?.reloadData()
        view?.updateTitle("Список друзей")
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(friendAdded(_:)), name: .didAddFriend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(friendDeleted(_:)), name: .didDeleteFriend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(friendEdited(_:)), name: .didEditFriend, object: nil)
    }
    
    @objc private func friendAdded(_ notification: Notification) {
        guard let newFriend = notification.object as? Friend else { return }
        addFriend(newFriend)
    }
    
    @objc private func friendDeleted(_ notification: Notification) {
        guard let index = notification.object as? Int else { return }
        deleteFriend(at: index)
    }
    
    @objc private func friendEdited(_ notification: Notification) {
        guard let (updatedFriend, index) = notification.object as? (Friend, Int) else { return }
        updateFriend(updatedFriend, at: index)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FriendsListPresenter: FriendsListPresenterInput {
    
    // MARK: Internal functions
    
    func numberOfFriends() -> Int {
        friends.count
    }
    
    func friend(at index: Int) -> Friend? {
        guard index < friends.count else { return nil }
        return friends[index]
    }
    
    func addFriend(_ friend: Friend) {
        friends.append(friend)
        FriendsDataManager.shared.setFriends(friends)
        view?.reloadData()
    }
    
    func updateFriend(_ friend: Friend, at index: Int) {
        guard index < friends.count else { return }
        friends[index] = friend
        FriendsDataManager.shared.setFriends(friends)
        view?.reloadData()
    }
    
    func deleteFriend(at index: Int) {
        guard index < friends.count else { return }
        friends.remove(at: index)
        FriendsDataManager.shared.setFriends(friends)
        view?.reloadData()
    }
}

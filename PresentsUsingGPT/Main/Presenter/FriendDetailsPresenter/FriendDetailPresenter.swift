//
//  FriendDetailPresenter.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

final class FriendDetailPresenter: FriendDetailPresenterInput {
    
    weak var view: FriendDetailViewControllerInput?
    private var friend: Friend
    private var friendIndex: Int
    
    init(friend: Friend, index: Int) {
        self.friend = friend
        self.friendIndex = index
    }
    
    func loadFriend() {
        view?.updateUI(friend: friend)
    }
    
    func handleFriendEdited(friend: Friend) {
        self.friend = friend
        view?.updateUI(friend: self.friend)
    }
    
    func getFriendIndex() -> Int {
        return friendIndex
    }
    
    func getFriend() -> Friend {
        return friend
    }
    
    func editFriend() {
        view?.showError(message: "Редактирование друга")
    }
    
    func deleteFriend() {
        view?.showError(message: "Удаление друга")
    }
    
    func handleGiftButtonTapped() {
        view?.showError(message: "Выбор ИИ для чата")
    }
}

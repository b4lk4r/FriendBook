//
//  FriendsListPresenterTests.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

import XCTest
@testable import PresentsUsingGPT

class FriendsListPresenterTests: XCTestCase {
    
    var presenter: FriendsListPresenter!
    var mockView: MockFriendsListViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockView = MockFriendsListViewController()
        
        presenter = FriendsListPresenter()
        presenter.view = mockView
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        mockView = nil
        try super.tearDownWithError()
    }
    
    // MARK: Test cases
    
    func testAddFriend() {
        let newFriend = Friend(firstName: "Елена", lastName: "Лебедева", role: "знакомая", birthDate: Date(), gender: "Мужской", interests: "Помогать", hobbies: "Общение")
        
        presenter.addFriend(newFriend)
        
        XCTAssertEqual(mockView.reloadDataCallCount, 1)
    }
    
    func testUpdateFriend() {
        let existingFriend = Friend(firstName: "Елена", lastName: "Лебедева", role: "знакомая", birthDate: Date(), gender: "Мужской", interests: "Помогать", hobbies: "Общение")
        presenter.addFriend(existingFriend)
        
        let updatedFriend = Friend(firstName: "Елена", lastName: "Лебедева", role: "знакомая", birthDate: Date(), gender: "Мужской", interests: "Помогать", hobbies: "Общение")

        presenter.updateFriend(updatedFriend, at: 0)
        
        XCTAssertEqual(mockView.reloadDataCallCount, 2)
    }
    
    func testDeleteFriend() {
        let friendToDelete = Friend(firstName: "Елена", lastName: "Лебедева", role: "знакомая", birthDate: Date(), gender: "Мужской", interests: "Помогать", hobbies: "Общение")
        presenter.addFriend(friendToDelete)
        
        presenter.deleteFriend(at: 0)
        
        XCTAssertEqual(mockView.reloadDataCallCount, 2)
    }
    
    func testNumberOfFriends() {
        let friend1 = Friend(firstName: "Елена", lastName: "Лебедева", role: "знакомая", birthDate: Date(), gender: "Мужской", interests: "Помогать", hobbies: "Общение")
        let friend2 = Friend(firstName: "Даниил", lastName: "Любушкин", role: "знакомая", birthDate: Date(), gender: "Мужской", interests: "Помогать", hobbies: "Общение")
        
        presenter.addFriend(friend1)
        presenter.addFriend(friend2)
        
        XCTAssertEqual(presenter.numberOfFriends(), 2)
    }
    
    func testFriendAtIndex() {
        let friend = Friend(firstName: "Елена", lastName: "Лебедева", role: "знакомая", birthDate: Date(), gender: "Мужской", interests: "Помогать", hobbies: "Общение")
        presenter.addFriend(friend)
        
        XCTAssertEqual(presenter.friend(at: 0)?.firstName, "Елена")
        XCTAssertNil(presenter.friend(at: 1))
    }
}

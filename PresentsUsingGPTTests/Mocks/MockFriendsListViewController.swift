//
//  Untitled.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 04.06.2025.
//

@testable import PresentsUsingGPT

class MockFriendsListViewController: FriendsListViewControllerInput {
    var reloadDataCallCount = 0
    var updateTitleCallCount = 0
    var titlePassed: String?
    
    func reloadData() {
        reloadDataCallCount += 1
    }
    
    func updateTitle(_ title: String) {
        updateTitleCallCount += 1
        titlePassed = title
    }
    
    func showResponse(_ response: String) {}
    
    func showError(_ message: String) {}
}

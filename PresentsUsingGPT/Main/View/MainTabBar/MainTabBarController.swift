import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: Internal functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    // MARK: Private functions

    private func setupTabs() {
        let friendsNav = UINavigationController(rootViewController: AppModule.shared.resolve(FriendsListViewControllerInput.self) as! UIViewController)
        let chatNav = UINavigationController(rootViewController: AppModule.shared.resolve(ChatViewControllerInput.self) as! UIViewController)
        let loverNav = UINavigationController(rootViewController: LoverViewController())
        
        friendsNav.tabBarItem = createTabBarItem(
            imageName: "house",
            title: nil
        )
        
        chatNav.tabBarItem = createTabBarItem(
            imageName: "chat_ai",
            title: nil
        )
        
        loverNav.tabBarItem = createTabBarItem(
            imageName: "compatibility",
            title: nil
        )

        viewControllers = [friendsNav, chatNav, loverNav]
    }
    
    private func createTabBarItem(imageName: String, title: String?) -> UITabBarItem {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        
        let item = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        return item
    }
}

// MARK: Extension

extension MainTabBarController: MainTabBarControllerInput {
    
    // MARK: Internal functions
    
    func openChat(with friend: Friend, aiName: String) {
        if let chatNav = viewControllers?[1] as? UINavigationController,
           let chatVC = chatNav.viewControllers.first as? ChatViewController {
            chatVC.configure(with: friend, aiName: aiName)
            chatVC.sendMessage(isFromUser: true)
            selectedIndex = 1
        }
    }
}

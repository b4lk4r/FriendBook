//
//  AppModule.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Swinject

final class AppModule {
    
    // MARK: Static internal properties
    
    static let shared  = AppModule()
    
    // MARK: Internal properties
    
    let container: Container
    
    // MARK: Init
    
    private init() {
        container = Container()
        
        container.register(NetworkClientInput.self) { _ in NetworkClient() }.inObjectScope(.container)
        container.register(KeychainManagerInput.self) { _ in KeychainManager() }.inObjectScope(.container)
        container.register(GigaChatServiceInput.self) { r in
            GigaChatService(
                networkClient: r.resolve(NetworkClientInput.self)!,
                keychainManager: r.resolve(KeychainManagerInput.self)!,
                gigaChatAuthURL: AppConfig.gigachatAuthURL,
                gigaChatURL: AppConfig.gigachatURL
            )
        }
        container.register(GeminiServiceInput.self) { r in
            GeminiService(
                networkClient: r.resolve(NetworkClientInput.self)!,
                keychainManager: r.resolve(KeychainManagerInput.self)!,
                geminiURL: AppConfig.geminiURL
            )
        }
        container.register(FriendsListPresenterInput.self) { _ in
            FriendsListPresenter()
        }
        container.register(FriendsListViewControllerInput.self) { r in
            let presenter = r.resolve(FriendsListPresenterInput.self)!
            let viewController = FriendsListViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        container.register(MainTabBarController.self) { r in
            return MainTabBarController()
        }
        container.register(ChatViewControllerPresenterInput.self) { r in
            ChatViewControllerPresenter(
                gigaChatService: r.resolve(GigaChatServiceInput.self)!,
                geminiService: r.resolve(GeminiServiceInput.self)!
            )
        }
        container.register(ChatViewControllerInput.self) { r in
            let presenter = r.resolve(ChatViewControllerPresenterInput.self)!
            let viewController = ChatViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    // MARK: Internal functions
    
    func resolve<T>(_ type: T.Type) -> T {
        return container.resolve(type)!
    }
}

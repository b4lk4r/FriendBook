//
//  MainSceneAssembly.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import UIKit

final class MainSceneAssembler {
    
    // MARK: Internal functions
    
    func makeScene() -> UIViewController {
        let viewController = AppModule.shared.resolve(MainTabBarController.self)
        return viewController /*as! ViewController*/
    }
}

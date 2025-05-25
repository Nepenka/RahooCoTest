//
//  AppCoordinator.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import Foundation
import UIKit

final class AppCoordinator {
    
    var window: UIWindow
       private var navigationController: UINavigationController

       init(window: UIWindow) {
           self.window = window
           self.navigationController = UINavigationController()
       }

    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(splashFinished), name: .splashDidFinish, object: nil)

        let splashVC = SplashViewController()
        navigationController.setViewControllers([splashVC], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    @objc private func splashFinished() {
        showMenu()
    }

    private func showMenu() {
        let menuVC = MenuViewController()
        navigationController.setViewControllers([menuVC], animated: true)
        
    }
}

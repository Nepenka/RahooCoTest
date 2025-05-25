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
    
    private func showGame() {
        let viewModel = GameViewModel()
        let gameVc = GameViewController(viewModel: viewModel)
        
        viewModel.onBackButtonTapped = { [weak self] in
            self?.showMenu()
        }
        navigationController.setViewControllers([gameVc], animated: true)
    }

    private func showMenu() {
        let viewModel = MenuViewModel()

            viewModel.onPlayButtonTapped = { [weak self] in
                self?.showGame()
            }
        

            let menuVC = MenuViewController(viewModel: viewModel)
            navigationController.setViewControllers([menuVC], animated: false)
        
    }
    
//    private func showSetting() {
//        let viewModel = SettingViewModel()
//        let settingVc = SettingViewController(viewModel: viewModel)
//        navigationController.setViewControllers([settingVc], animated: true)
//    }
}

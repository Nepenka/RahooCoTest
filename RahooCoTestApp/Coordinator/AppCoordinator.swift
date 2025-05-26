//
//  AppCoordinator.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import Foundation
import UIKit
import SpriteKit

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
    
    private func showWinScreen(moviesCount: Int, timeString: String, backgroundScene: SKScene?) {
        let winVM = WinViewModel(moviesCount: moviesCount,
                               timeString: timeString,
                               backgroundScene: backgroundScene)
        
        winVM.onAgainButtonTapped = { [weak self] in
            self?.navigationController.dismiss(animated: true) {
                self?.showGame()
            }
        }
        
        winVM.onMenuButtonTapped = { [weak self] in
            self?.navigationController.dismiss(animated: true) {
                self?.showMenu()
            }
        }
        
        let winVC = WinViewController(viewModel: winVM)
        navigationController.present(winVC, animated: true)
    }
    
    private func showGame() {
        let viewModel = GameViewModel()
        let gameVC = GameViewController(viewModel: viewModel)
        
        viewModel.onBackButtonTapped = { [weak self] in
            self?.showMenu()
        }
        
        viewModel.onSettingTapped = { [weak self] in
            self?.showSetting()
        }
        
        viewModel.onGameCompleted = { [weak self] movesCount, timeString in
            self?.showWinScreen(moviesCount: movesCount,
                              timeString: timeString,
                              backgroundScene: gameVC.skView.scene)
        }
        
        navigationController.setViewControllers([gameVC], animated: true)
    }

    private func showMenu() {
        let viewModel = MenuViewModel()
        
        viewModel.onPlayButtonTapped = { [weak self] in
            self?.showGame()
        }
        
        let menuVC = MenuViewController(viewModel: viewModel)
        navigationController.setViewControllers([menuVC], animated: false)
    }
    
    private func showSetting() {
        let viewModel = SettingViewModel()
        let settingVc = SettingViewController(viewModel: viewModel)
        
        viewModel.onSettingBackButton = { [weak self] in
            self?.showGame()
        }
        navigationController.setViewControllers([settingVc], animated: true)
    }
}

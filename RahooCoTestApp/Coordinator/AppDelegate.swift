//
//  AppDelegate.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
        var appCoordinator: AppCoordinator?

        func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window

            let coordinator = AppCoordinator(window: window)
            self.appCoordinator = coordinator
            coordinator.start()

            return true
        }
}


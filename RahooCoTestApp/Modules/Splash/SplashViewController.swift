//
//  SplashViewController.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import SpriteKit
import UIKit
import Foundation


class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let skView = SKView(frame: view.bounds)
        view.addSubview(skView)
        
        let scene = SplashScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
}

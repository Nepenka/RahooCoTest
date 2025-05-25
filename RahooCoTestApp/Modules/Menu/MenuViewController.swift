//
//  MenuViewController.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import UIKit
import SnapKit
import SpriteKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = SKView(frame: view.bounds)
        view.addSubview(skView)
        
        let scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
}

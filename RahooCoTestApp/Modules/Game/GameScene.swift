//
//  GameScene.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import UIKit
import SpriteKit


class GameScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        setupGameBackground()
    }
    
    private func setupGameBackground() {
        let background = SKSpriteNode(imageNamed: "Bg_2")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 0
        background.size = CGSize(width: self.size.width * 2, height: self.size.height)
        addChild(background)
    }
}

//
//  WinScene.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 26/05/2025.
//

import UIKit
import SpriteKit

final class WinScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Bg_2")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.size = size
        addChild(background)
        
        
    }
}

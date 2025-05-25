//
//  MenuScene.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import SpriteKit
import UIKit

class MenuScene: SKScene {
   
    var crownScene: SKSpriteNode? = nil
    
    override func didMove(to view: SKView) {
        setupMenuBackground()
        setupFire()
        setupCrown()
        setupCrownAnimation()
    }
    
    
    private func setupMenuBackground() {
        let background = SKSpriteNode(imageNamed: "Bg_1")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 0
        background.size = CGSize(width: self.size.width * 1.3, height: self.size.height)
        addChild(background)
    }
    
    private func setupFire() {
        let fire = SKSpriteNode(imageNamed: "Bg_3")
        fire.position = CGPoint(x: size.width / 2, y: size.height / 2)
        fire.zPosition = 1
        fire.size = CGSize(width: self.size.width * 2, height: self.size.height)
        addChild(fire)
    }
    
    private func setupCrown() {
        let crown = SKSpriteNode(imageNamed: "crown")
        crown.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        crown.zPosition = 2
        crown.size = CGSize(width: self.size.width / 1.5, height: self.size.height / 2.5)
        crownScene = crown
        addChild(crown)
    }
    
    private func setupCrownAnimation() {
        guard let crownScene = crownScene else { return }
        
        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 1.0)
        let moveDown = SKAction.moveBy(x: 0, y: -10, duration: 1.0)
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeatForever = SKAction.repeatForever(sequence)
        
        crownScene.run(repeatForever)
    }
}

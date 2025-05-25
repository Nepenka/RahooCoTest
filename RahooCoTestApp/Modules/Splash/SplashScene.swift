//
//  SplashScene.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import SpriteKit
import UIKit


class SplashScene: SKScene {
    
    private var fireNode: SKSpriteNode?
    
    private let loadingLabel: SKLabelNode = {
        let loadingLabel = SKLabelNode(text: "Loading...")
        loadingLabel.fontName = "Muller"
        loadingLabel.fontSize = 36
        loadingLabel.fontColor = .white
        return loadingLabel
    }()
    
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupFire()
        setupFireAnimation()
        setupLoadingLabel()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            NotificationCenter.default.post(name: .splashDidFinish, object: nil)
        }
    }
    
    private func setupBackground() {
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
        fireNode = fire
        addChild(fire)
    }
    
    private func setupLoadingLabel() {
        guard let fireNode = fireNode else {return}
            loadingLabel.position = CGPoint(x: 0, y: -25)
            loadingLabel.zPosition = 2
        fireNode.addChild(loadingLabel)
        }

    
    private func setupFireAnimation() {
        guard let fireNode = fireNode else { return }
        
        let moveUp = SKAction.moveBy(x: 0, y: 25, duration: 1.0)
        let moveDown = SKAction.moveBy(x: 0, y: -25, duration: 1.0)
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeatForever = SKAction.repeatForever(sequence)
        
        fireNode.run(repeatForever)
    }
}

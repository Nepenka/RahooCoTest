//
//  WinViewModel.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 26/05/2025.
//

import UIKit
import SpriteKit
import AVFoundation

final class WinViewModel {
    let moviesCount: Int
    let timeString: String
    var backgroundScene: SKScene?
    private var onContinue: (() -> Void)?
    var onAgainButtonTapped: (() -> Void)?
    var onMenuButtonTapped: (() -> Void)?
    private var audioSettingPlayer: AVAudioPlayer?
    
    init(moviesCount: Int, timeString: String, backgroundScene: SKScene? = nil) {
        self.moviesCount = moviesCount
        self.timeString = timeString
        self.backgroundScene = backgroundScene
    }
    
    
    func playButtonClick() {
        guard SettingsManager.shared.isSoundEnabled else { return }
        guard let soundURL = Bundle.main.url(forResource: "zvukKnopki", withExtension: "mp3") else { return }
        do {
            audioSettingPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioSettingPlayer?.prepareToPlay()
            audioSettingPlayer?.volume = 0.3
            audioSettingPlayer?.play()
        } catch {
            print("Ошибка звука кнопки: \(error.localizedDescription)")
        }
    }
    
    func playBackgroundMusic() {
        guard SettingsManager.shared.isSoundEnabled else {
            stopBackgroundMusic()
            return
        }
        SoundManager.shared.playBackgroundMusic()
    }
    
    func stopBackgroundMusic() {
        SoundManager.shared.stopBackgroundMusic()
    }
    
    func handleAgainButton() {
        onAgainButtonTapped?()
    }
        
    func handleMenuButton() {
        onMenuButtonTapped?()
    }
}

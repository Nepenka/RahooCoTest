//
//  SettingViewModel.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 26/05/2025.
//

import UIKit
import AVFoundation


final class SettingViewModel {
    var offMusicButton: (() -> Void)? = nil
    var offVibrationButton: (() -> Void)? = nil
    var onSettingBackButton: (() -> Void)?
    
    private var audioSettingPlayer: AVAudioPlayer?
    
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
    
    func toggleMusicSetting() {
        let current = SettingsManager.shared.isSoundEnabled
        SettingsManager.shared.isSoundEnabled = !current
        if SettingsManager.shared.isSoundEnabled {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
        playButtonClick()
    }
    
    func tappedVibrationButton() {
        let current = SettingsManager.shared.isVibrationEnabled
        SettingsManager.shared.isVibrationEnabled = !current
        playButtonClick()
        offVibrationButton?()
    }
    
    func tappedBackButton() {
        onSettingBackButton?()
    }
}

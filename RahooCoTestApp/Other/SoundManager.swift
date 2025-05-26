//
//  SoundManager.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 26/05/2025.
//

import AVFoundation

final class SoundManager {
    static let shared = SoundManager()

    private var backgroundPlayer: AVAudioPlayer?

    private init() {}

    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "background", withExtension: "mp3") else { return }

        if let player = backgroundPlayer, player.isPlaying {
            return
        }

        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1
            backgroundPlayer?.volume = 0.3
            backgroundPlayer?.prepareToPlay()
            backgroundPlayer?.play()
        } catch {
            print("Ошибка воспроизведения: \(error)")
        }
    }

    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
    }

    func pauseBackgroundMusic() {
        backgroundPlayer?.pause()
    }

    func resumeBackgroundMusic() {
        backgroundPlayer?.play()
    }
}

//
//  GameViewModel.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//


import Foundation
import AVFoundation

final class GameViewModel {
    
    // MARK: - Properties
    var cards: [Card] = []
    var flippedCards: [Int] = []
    var movesCount = 0
    private(set) var secondsPlayed = 0 {
        didSet {
            let minutes = secondsPlayed / 60
            let seconds = secondsPlayed % 60
            onTimerUpdate?(minutes, seconds)
        }
    }
    private(set) var isPaused = false
    private var pausedTime = 0
    
    var onMatchFound: ((Int, Int) -> Void)?
    var onMismatch: ((Int, Int) -> Void)?
    var onTimerUpdate: ((Int, Int) -> Void)?
    var onGameCompleted: (() -> Void)?
    var onSettingTapped: (() -> Void)?
    var onBackButtonTapped: (() -> Void)?
    var onGameReset: (() -> Void)?
    var onMovesChanged: ((Int) -> Void)?

    
    private var isInteractionLocked = false
    private var gameTimer: Timer?
    private var backgroundMusic: AVAudioPlayer?
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Init
    init() {
        setupCards()
    }
    
    // MARK: - Setup
    func setupCards() {
        let cardImages = [
            "blueglassSlot", "emeraldSlot", "goldcardSlot",
            "golddrumSlot", "goldenringSlot", "machineSlot",
            "raspberrySlot", "strawberrySlot"
        ]
        var cardPairs = cardImages + cardImages
        cardPairs.shuffle()
        cardPairs = Array(cardPairs.prefix(16))
        
        cards = cardPairs.enumerated().map { index, imageName in
            Card(id: index, imageName: imageName)
        }
    }
    
    // MARK: - Timer Methods
    func startGameTimer() {
        if isPaused {
            secondsPlayed = pausedTime
        }
        
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isPaused else { return }
            self.secondsPlayed += 1
        }
    }
    
    func stopGameTimer() {
        gameTimer?.invalidate()
    }
    
    func togglePause() {
            if isPaused {
                isPaused = false
                isInteractionLocked = false
                startGameTimer()
            } else {
                isPaused = true
                pausedTime = secondsPlayed
                isInteractionLocked = true
                stopGameTimer()
            }
        }
    
    func resetGame() {
        secondsPlayed = 0
        let minutes = secondsPlayed / 60
        let seconds = secondsPlayed % 60
        onTimerUpdate?(minutes, seconds)
        stopGameTimer()
        
        for index in cards.indices {
            cards[index].isFlipped = false
            cards[index].isMatched = false
        }
        flippedCards.removeAll()
        isInteractionLocked = false
        movesCount = 0
        onMovesChanged?(movesCount)
        setupCards()
        DispatchQueue.main.async { [weak self] in
            self?.onGameReset?()
        }
        
    }
    
    // MARK: - Sound Methods
    func playButtonClick() {
        guard let soundURL = Bundle.main.url(forResource: "zvukKnopki", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            audioPlayer?.volume = 0.3
        } catch {
            print("Ошибка звука кнопки: \(error.localizedDescription)")
        }
    }
    
    func backgroundSound() {
        guard let backgroundURL = Bundle.main.url(forResource: "background", withExtension: "mp3") else { return }
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: backgroundURL)
            backgroundMusic?.prepareToPlay()
            backgroundMusic?.volume = 0.3
            backgroundMusic?.numberOfLoops = -1
            backgroundMusic?.play()
        } catch {
            print("Ошибка фоновой музыки: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Game Logic
    func handleCardFlip(at index: Int) -> Bool {
        guard !cards[index].isFlipped,
              !cards[index].isMatched,
              flippedCards.count < 2,
              !isInteractionLocked else { return false }
        
        cards[index].isFlipped = true
        flippedCards.append(index)
        
        if flippedCards.count == 2 {
            movesCount += 1
            onMovesChanged?(movesCount)
            isInteractionLocked = true
            checkForMatch()
        }
        
        return true
    }
    
    private func checkForMatch() {
        let firstIndex = flippedCards[0]
        let secondIndex = flippedCards[1]
        
        if cards[firstIndex].imageName == cards[secondIndex].imageName {
            cards[firstIndex].isMatched = true
            cards[secondIndex].isMatched = true
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.onMatchFound?(firstIndex, secondIndex)
                self?.flippedCards.removeAll()
                self?.isInteractionLocked = false
                self?.checkGameCompletion()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.cards[firstIndex].isFlipped = false
                self?.cards[secondIndex].isFlipped = false
                self?.onMismatch?(firstIndex, secondIndex)
                self?.flippedCards.removeAll()
                self?.isInteractionLocked = false
            }
        }
    }
    
    private func checkGameCompletion() {
        if cards.allSatisfy({ $0.isMatched }) {
            onGameCompleted?()
        }
    }
    
    // MARK: - Actions
    func settingButtonTapped() {
        onSettingTapped?()
    }
    
    func backButtonTapped() {
        onBackButtonTapped?()
    }
    
    deinit {
        gameTimer?.invalidate()
    }
}

//
//  GameViewController.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import UIKit
import SpriteKit
import SnapKit
import AVFoundation

class GameViewController: UIViewController {

    // MARK: - UI Components
    private let viewModel: GameViewModel
    private let skView = SKView()
    private let gridView = UIView()
    private var cardButtons: [UIButton] = []
    private let timeLabel = UILabel()
    private let moviesLabel = UILabel()
    private var isPaused = false

    private let settingButton: UIButton = {
        let setting = UIButton()
        setting.setImage(UIImage(named: "settingButton"), for: .normal)
        return setting
    }()
    
    private let pauseButton: UIButton = {
       let pause = UIButton()
        pause.setImage(UIImage(named: "pauseButton"), for: .normal)
        return pause
    }()
    
    private let backButton: UIButton = {
        let back = UIButton()
        back.setImage(UIImage(named: "leftButton"), for: .normal)
        return back
    }()
    
    private let refreshButton: UIButton = {
        let refresh = UIButton()
        refresh.setImage(UIImage(named: "refreshButton"), for: .normal)
        return refresh
    }()

    // MARK: - Init
    init(viewModel: GameViewModel = GameViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSKView()
        setupButtons()
        bindViewModel()
        setupCustomImageLabel()
        viewModel.startGameTimer()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.backgroundSound()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if skView.scene == nil && skView.bounds.size != .zero {
            let scene = GameScene(size: skView.bounds.size)
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }

    // MARK: - Setup
    private func setupSKView() {
        view.addSubview(skView)
        skView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    

    private func setupButtons() {
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(45)
            $0.height.equalTo(45)
        }
        
        gridView.backgroundColor = .clear
        view.addSubview(gridView)
        gridView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(view.snp.width).multipliedBy(0.9)
            $0.height.equalTo(gridView.snp.width)
        }
        
        view.addSubview(pauseButton)
        pauseButton.snp.makeConstraints {
            $0.top.equalTo(gridView.snp.bottom).offset(115)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(45)
            $0.height.equalTo(45)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(gridView.snp.bottom).offset(115)
            $0.left.equalTo(pauseButton.snp.right).offset(100)
            $0.width.equalTo(45)
            $0.height.equalTo(45)
        }
        
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints {
            $0.top.equalTo(gridView.snp.bottom).offset(115)
            $0.left.equalTo(backButton.snp.right).offset(90)
            $0.width.equalTo(45)
            $0.height.equalTo(45)
        }
        
        settingButton.addTarget(self, action: #selector(settingTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
        setupCards()
    }
    
    private func setupCustomImageLabel() {
        let imageView = UIImageView(image: UIImage(named: "redBackground"))
        imageView.contentMode = .scaleToFill
        view.addSubview(imageView)
        
        
        moviesLabel.text = "MOVIES: 0"
        moviesLabel.textColor = .white
        moviesLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        moviesLabel.textAlignment = .left 
        imageView.addSubview(moviesLabel)
        
        
        
        timeLabel.text = "TIME: 00:00"
        timeLabel.textColor = .white
        timeLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        timeLabel.textAlignment = .right
        imageView.addSubview(timeLabel)
        

        imageView.snp.makeConstraints {
            $0.top.equalTo(settingButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }

        moviesLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }

        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func updatePauseButtonImage() {
            let imageName = viewModel.isPaused ? "playButton" : "pauseButton"
            pauseButton.setImage(UIImage(named: imageName), for: .normal)
        }
        
    private func setupCards() {
        let rows = 4
        let columns = 4
        let spacing: CGFloat = 15

        cardButtons.removeAll()
        gridView.subviews.forEach { $0.removeFromSuperview() }

        gridView.layoutIfNeeded()
        let availableWidth = gridView.bounds.width - CGFloat(columns - 1) * spacing
        let cellWidth = availableWidth / CGFloat(columns)

        for row in 0..<rows {
            for column in 0..<columns {
                let index = row * columns + column
                let button = UIButton()
                button.tag = index
                button.setImage(UIImage(named: "closeSlot"), for: .normal)
                button.layer.cornerRadius = 8
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.white.cgColor
                button.addTarget(self, action: #selector(cardTapped(_:)), for: .touchUpInside)

                gridView.addSubview(button)
                cardButtons.append(button)

                button.snp.makeConstraints { make in
                    make.width.height.equalTo(cellWidth)
                    if row == 0 {
                        make.top.equalToSuperview()
                    } else {
                        make.top.equalTo(cardButtons[(row - 1) * columns + column].snp.bottom).offset(spacing)
                    }
                    if column == 0 {
                        make.leading.equalToSuperview()
                    } else {
                        make.leading.equalTo(cardButtons[row * columns + column - 1].snp.trailing).offset(spacing)
                    }
                }
            }
        }
    }

    private func bindViewModel() {
        viewModel.onMatchFound = { [weak self] first, second in
            guard let self else { return }
            self.cardButtons[first].alpha = 0.5
            self.cardButtons[second].alpha = 0.5
        }

        viewModel.onMismatch = { [weak self] first, second in
            guard let self else { return }
            self.flipCard(at: first, faceUp: false)
            self.flipCard(at: second, faceUp: false)
        }
        
        viewModel.onTimerUpdate = { minute,seconds in
            self.timeLabel.text = String(format: "TIME: %02d:%02d", minute, seconds)
        }
        
        viewModel.onGameReset = { [weak self] in
            self?.closeAllCards()
        }
        
        viewModel.onMovesChanged = { [weak self] count in
            self?.moviesLabel.text = "MOVIES: \(count)"
        }
        
        
        
    }
    
    // MARK: - Actions
    @objc private func settingTapped() {
        if SettingsManager.shared.isVibrationEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        if SettingsManager.shared.isSoundEnabled {
            viewModel.playButtonClick()
        }
        viewModel.settingButtonTapped()
    }
    
    @objc private func backTapped() {
        if SettingsManager.shared.isVibrationEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        if SettingsManager.shared.isSoundEnabled {
            viewModel.playButtonClick()
        }
        viewModel.backButtonTapped()
    }

    @objc private func cardTapped(_ sender: UIButton) {
        if SettingsManager.shared.isVibrationEnabled {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        let index = sender.tag
        let shouldFlip = viewModel.handleCardFlip(at: index)
        
        if shouldFlip {
            flipCard(at: index, faceUp: true)
        }
    }
    
    @objc private func pauseTapped() {
        if SettingsManager.shared.isVibrationEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        if SettingsManager.shared.isSoundEnabled {
            viewModel.playButtonClick()
        }
        viewModel.togglePause()
        updatePauseButtonImage()
    }
    
    @objc private func refreshTapped() {
        if SettingsManager.shared.isVibrationEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        viewModel.resetGame()
        viewModel.startGameTimer()
    }
    
    private func flipCard(at index: Int, faceUp: Bool) {
        UIView.transition(with: cardButtons[index],
                          duration: 0.3,
                          options: .transitionFlipFromLeft,
                          animations: {
            self.cardButtons[index].setImage(
                UIImage(named: faceUp ? self.viewModel.cards[index].imageName : "closeSlot"),
                for: .normal
            )
        })
    }
    
    private func closeAllCards() {
        for (index, button) in cardButtons.enumerated() {
            button.alpha = 1.0
            UIView.transition(with: button,
                              duration: 0.3,
                              options: .transitionFlipFromRight,
                              animations: {
                button.setImage(UIImage(named: "closeSlot"), for: .normal)
            })
        }
    }
}

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

    private let viewModel: GameViewModel
    let skView = SKView()
    private let gridView = UIView()
    private var cardButtons: [UIButton] = []
    private let timeLabel = UILabel()
    private let moviesLabel = UILabel()
    private var isPaused = false

    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settingButton"), for: .normal)
        return button
    }()

    private let pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pauseButton"), for: .normal)
        return button
    }()

    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "leftButton"), for: .normal)
        return button
    }()

    private let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "refreshButton"), for: .normal)
        return button
    }()

    init(viewModel: GameViewModel = GameViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    private func setupSKView() {
        view.addSubview(skView)
        skView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func setupButtons() {
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(45)
        }

        gridView.backgroundColor = .clear
        view.addSubview(gridView)
        gridView.snp.makeConstraints {
            $0.top.equalTo(settingButton.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.snp.width).multipliedBy(0.9)
            $0.height.equalTo(gridView.snp.width)
        }

        setupCards()

        let controlStack = UIStackView(arrangedSubviews: [pauseButton, backButton, refreshButton])
        controlStack.axis = .horizontal
        controlStack.spacing = 85
        controlStack.distribution = .equalSpacing
        view.addSubview(controlStack)

        controlStack.snp.makeConstraints {
            $0.top.equalTo(gridView.snp.bottom).offset(75)
            $0.centerX.equalToSuperview()
        }

        [pauseButton, backButton, refreshButton].forEach { button in
            button.snp.makeConstraints {
                $0.width.height.equalTo(45)
            }
        }

        settingButton.addTarget(self, action: #selector(settingTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
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

    private func setupCards() {
        let rows = 4
        let columns = 4
        let spacing: CGFloat = 10

        cardButtons.removeAll()
        gridView.subviews.forEach { $0.removeFromSuperview() }

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = spacing
        mainStack.distribution = .fillEqually

        for _ in 0..<rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = spacing
            rowStack.distribution = .fillEqually

            for _ in 0..<columns {
                let button = UIButton()
                button.setImage(UIImage(named: "closeSlot"), for: .normal)
                button.layer.cornerRadius = 8
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.white.cgColor
                button.tag = cardButtons.count
                button.addTarget(self, action: #selector(cardTapped(_:)), for: .touchUpInside)
                cardButtons.append(button)
                rowStack.addArrangedSubview(button)
            }

            mainStack.addArrangedSubview(rowStack)
        }

        gridView.addSubview(mainStack)
        mainStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func updatePauseButtonImage() {
        let imageName = viewModel.isPaused ? "playButton" : "pauseButton"
        pauseButton.setImage(UIImage(named: imageName), for: .normal)
    }

    private func showWinScreen(moviesCount: Int, timeString: String) {
        let winVM = WinViewModel(moviesCount: moviesCount, timeString: timeString, backgroundScene: skView.scene)
        let winVC = WinViewController(viewModel: winVM)
        winVC.modalPresentationStyle = .overFullScreen
        present(winVC, animated: true)
    }

    private func bindViewModel() {
        viewModel.onMatchFound = { [weak self] first, second in
            self?.cardButtons[first].alpha = 0.5
            self?.cardButtons[second].alpha = 0.5
        }

        viewModel.onMismatch = { [weak self] first, second in
            self?.flipCard(at: first, faceUp: false)
            self?.flipCard(at: second, faceUp: false)
        }

        viewModel.onTimerUpdate = { [weak self] minute, seconds in
            self?.timeLabel.text = String(format: "TIME: %02d:%02d", minute, seconds)
        }

        viewModel.onGameReset = { [weak self] in
            self?.closeAllCards()
        }

        viewModel.onMovesChanged = { [weak self] count in
            self?.moviesLabel.text = "MOVIES: \(count)"
        }

        viewModel.onGameCompleted = { [weak self] movesCount, timeString in
            self?.showWinScreen(moviesCount: movesCount, timeString: timeString)
        }
    }

    @objc private func settingTapped() {
        if SettingsManager.shared.isVibrationEnabled {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        if SettingsManager.shared.isSoundEnabled {
            viewModel.playButtonClick()
        }
        viewModel.settingButtonTapped()
    }

    @objc private func backTapped() {
        if SettingsManager.shared.isVibrationEnabled {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        if SettingsManager.shared.isSoundEnabled {
            viewModel.playButtonClick()
        }
        viewModel.backButtonTapped()
    }

    @objc private func cardTapped(_ sender: UIButton) {
        if SettingsManager.shared.isVibrationEnabled {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        let index = sender.tag
        if viewModel.handleCardFlip(at: index) {
            flipCard(at: index, faceUp: true)
        }
    }

    @objc private func pauseTapped() {
        if SettingsManager.shared.isVibrationEnabled {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        if SettingsManager.shared.isSoundEnabled {
            viewModel.playButtonClick()
        }
        viewModel.togglePause()
        updatePauseButtonImage()
    }

    @objc private func refreshTapped() {
        if SettingsManager.shared.isVibrationEnabled {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        viewModel.resetGame()
        viewModel.startGameTimer()
    }

    private func flipCard(at index: Int, faceUp: Bool) {
        UIView.transition(with: cardButtons[index], duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.cardButtons[index].setImage(
                UIImage(named: faceUp ? self.viewModel.cards[index].imageName : "closeSlot"),
                for: .normal
            )
        })
    }

    private func closeAllCards() {
        for (index, button) in cardButtons.enumerated() {
            button.alpha = 1.0
            UIView.transition(with: button, duration: 0.3, options: .transitionFlipFromRight, animations: {
                button.setImage(UIImage(named: "closeSlot"), for: .normal)
            })
        }
    }
}

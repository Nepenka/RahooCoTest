//
//  MenuViewController.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import UIKit
import SnapKit
import SpriteKit
import SafariServices
import AVFoundation

final class MenuViewController: UIViewController {

    // MARK: - UI Components

    private let skView = SKView()
    private let viewModel: MenuViewModel?
    private var audioPlayer: AVAudioPlayer?

    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "gameButton"), for: .normal)
        return button
    }()

    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "privacypoliceButton"), for: .normal)
        return button
    }()

    // MARK: - Initialization

    init(viewModel: MenuViewModel?) {
        print("init MenuViewController with viewModel: \(viewModel != nil)")
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        setupSKView()
        setupButtons()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if skView.scene == nil && skView.bounds.size != .zero {
            let scene = MenuScene(size: skView.bounds.size)
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }

    // MARK: - Setup Methods

    private func setupSKView() {
        view.addSubview(skView)
        skView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func playButtonClick() {
        guard SettingsManager.shared.isSoundEnabled else { return }
        guard let soundURL = Bundle.main.url(forResource: "zvukKnopki", withExtension: "mp3") else {
            print(" Не найден zvukKnopki.mp3 в bundle")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            audioPlayer?.volume = 0.3
        } catch {
            print(" Ошибка воспроизведения звука: \(error.localizedDescription)")
        }
    }

    private func setupButtons() {
        view.addSubview(playButton)
        view.addSubview(privacyButton)

        playButton.snp.makeConstraints { play in
            play.centerX.equalToSuperview()
            play.centerY.equalToSuperview().offset(65)
            play.width.equalTo(220)
            play.height.equalTo(50)
        }

        privacyButton.snp.makeConstraints { privacy in
            privacy.top.equalTo(playButton.snp.bottom).offset(85)
            privacy.centerX.equalToSuperview()
            privacy.width.equalTo(190)
            privacy.height.equalTo(50)
        }

        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
    }
    
    
    // MARK: - ViewModel Binding

    private func bindViewModel() {

        viewModel?.onPrivacyButtonTapped = {
            self.playButtonClick()
            guard let url = URL(string: "https://google.com") else { return }
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
    }

    // MARK: - Actions

    @objc private func playTapped() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        self.playButtonClick()
        viewModel?.tappedPlayButton()
    }

    @objc private func privacyTapped() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        self.playButtonClick()
        viewModel?.tappedPrivacyButton()
    }
}

//
//  SettingViewController.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 26/05/2025.
//

import UIKit
import SnapKit
import SpriteKit
import AVFoundation

class SettingViewController: UIViewController {
    
    //MARK: - UI Components
    private let viewModel: SettingViewModel?
    private let skView = SKView()
    private let backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "leftButton"), for: .normal)
        return button
    }()
    private let unmuteButton: UIButton = {
       let unmute = UIButton()
        unmute.setImage(UIImage(named: "unmuteButton"), for: .normal)
        return unmute
    }()
    
    private let vibrationOnButton: UIButton = {
       let vibro = UIButton()
        vibro.setImage(UIImage(named: "vibrationOn"), for: .normal)
        return vibro
    }()
    
    private let noneMusic: UILabel = {
       let label = UILabel()
        label.text = "Убрать звук"
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        return label
    }()
    
    private let noneVibro: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.text = "Убрать вибрацию"
        label.textColor = .white
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        return label
    }()
    
    
    //MARK: - Initialization
    init(viewModel: SettingViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSKView()
        setupButton()
        updateUnmute()
        updateVibro()

    
        self.viewModel?.playBackgroundMusic()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if skView.scene == nil && skView.bounds.size != .zero {
            let scene = SettingScene(size: skView.bounds.size)
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
    
    private func setupButton() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(45)
            $0.height.equalTo(45)
        }
        
        view.addSubview(unmuteButton)
        unmuteButton.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(50)
            $0.right.equalToSuperview().offset(-25)
            $0.width.equalTo(45)
            $0.height.equalTo(45)
        }
        
        view.addSubview(vibrationOnButton)
        vibrationOnButton.snp.makeConstraints {
            $0.top.equalTo(unmuteButton.snp.bottom).offset(50)
            $0.right.equalToSuperview().offset(-25)
            $0.width.equalTo(45)
            $0.height.equalTo(45)
        }
        
        view.addSubview(noneMusic)
        noneMusic.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(50)
            $0.right.equalTo(unmuteButton.snp.left).offset(-40)
            $0.height.equalTo(45)
        }
        
        view.addSubview(noneVibro)
        noneVibro.snp.makeConstraints {
            $0.top.equalTo(noneMusic.snp.bottom).offset(50)
            $0.right.equalTo(vibrationOnButton.snp.left).offset(-25)
            $0.height.equalTo(45)
        }
        
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        unmuteButton.addTarget(self, action: #selector(unmuteAction), for: .touchUpInside)
        vibrationOnButton.addTarget(self, action: #selector(vibroAction), for: .touchUpInside)
    }
    
    private func updateUnmute() {
        let currentMute = SettingsManager.shared.isSoundEnabled
        let imageNameMute = currentMute ? "unmuteButton" : "muteButton"
        unmuteButton.setImage(UIImage(named: imageNameMute), for: .normal)
    }

    private func updateVibro() {
        let currentVibro = SettingsManager.shared.isVibrationEnabled
        let imageNameVibro = currentVibro ? "vibrationOn" : "vibrationOff"
        vibrationOnButton.setImage(UIImage(named: imageNameVibro), for: .normal)
    }
    
    @objc private func backButtonAction() {
        let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        viewModel?.playButtonClick()
        viewModel?.tappedBackButton()
    }
    
    @objc private func unmuteAction() {
        let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            viewModel?.toggleMusicSetting()
            updateUnmute()
    }

    @objc private func vibroAction() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        viewModel?.tappedVibrationButton()
        updateVibro()
    }
}

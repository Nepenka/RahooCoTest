//
//  WinViewController.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 26/05/2025.
//

import UIKit
import SpriteKit
import SnapKit

final class WinViewController: UIViewController {
    
    private let viewModel: WinViewModel
    private let skView = SKView()
    private let darkOverlay = UIView()
    
    private let backgroundImage = UIImageView(image: UIImage(named: "Bg_3"))
    private let winTitleImage = UIImageView(image: UIImage(named: "winTitle"))
    private let signView = UIImageView(image: UIImage(named: "signView"))
    
    private let moviesLabel = UILabel()
    private let timeLabel = UILabel()
    
    private let onAgainButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "againButton"), for: .normal)
        return button
    }()
    
    private let backToMenuButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "menuButton"), for: .normal)
        return button
    }()
    
    
    init(viewModel: WinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureUI()
        self.viewModel.playBackgroundMusic()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if skView.scene == nil {
            let scene = viewModel.backgroundScene ?? createDefaultScene()
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPulseAnimationToTitle()
    }
    
    private func setupViews() {
        view.addSubview(skView)
        view.addSubview(darkOverlay)
        view.addSubview(backgroundImage)
        view.addSubview(signView)
        view.addSubview(winTitleImage)
        view.addSubview(onAgainButton)
        view.addSubview(backToMenuButton)
        
        signView.addSubview(moviesLabel)
        signView.addSubview(timeLabel)
        signView.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        skView.snp.makeConstraints { $0.edges.equalToSuperview() }
        darkOverlay.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        backgroundImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(view.snp.width).multipliedBy(2)
            $0.height.equalTo(view.snp.height)
        }
        
        
        winTitleImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(signView.snp.top).offset(85)
            $0.width.equalTo(450)
            $0.height.equalTo(380)
        }
        
        signView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(150)
        }
        
        onAgainButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-20)
            $0.top.equalTo(signView.snp.bottom).offset(10)
            $0.height.equalTo(45)
            $0.width.equalTo(45)
        }
        
        backToMenuButton.snp.makeConstraints {
            $0.top.equalTo(signView.snp.bottom).offset(10)
            $0.left.equalTo(onAgainButton.snp.right).offset(10)
            $0.height.equalTo(45)
            $0.width.equalTo(45)
        }
        
        moviesLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(moviesLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    private func configureUI() {
        darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backgroundImage.contentMode = .scaleAspectFit
        winTitleImage.contentMode = .scaleAspectFit
        signView.contentMode = .scaleAspectFit
        
        moviesLabel.text = "MOVIES: \(viewModel.moviesCount)"
        moviesLabel.font = .systemFont(ofSize: 24, weight: .bold)
        moviesLabel.textColor = .white
        
        timeLabel.text = "TIME: \(viewModel.timeString)"
        timeLabel.font = .systemFont(ofSize: 24, weight: .bold)
        timeLabel.textColor = .white
        
        onAgainButton.addTarget(self, action: #selector(onAgainButtonAction), for: .touchUpInside)
        backToMenuButton.addTarget(self, action: #selector(backToMenuButtonAction), for: .touchUpInside)
    }
    
    private func addPulseAnimationToTitle() {
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: [.autoreverse, .repeat, .allowUserInteraction],
                       animations: {
            self.winTitleImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
    
    private func createDefaultScene() -> SKScene {
        let scene = WinScene(size: view.bounds.size)
        return scene
    }
    
    @objc private func onAgainButtonAction() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        viewModel.playButtonClick()
        dismiss(animated: true) {
            self.viewModel.handleAgainButton() 
        }
    }

    @objc private func backToMenuButtonAction() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        viewModel.playButtonClick()
        dismiss(animated: true) {
            self.viewModel.handleAgainButton() 
        }
          
    }
}

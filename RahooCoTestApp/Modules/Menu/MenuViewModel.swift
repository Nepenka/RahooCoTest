//
//  MenuViewModel.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 25/05/2025.
//

import UIKit


final class MenuViewModel {
    var onPlayButtonTapped: (() -> Void)? = nil
    var onPrivacyButtonTapped: (() -> Void)? = nil
    
    func tappedPlayButton() {
        onPlayButtonTapped?()
    }
    
    func tappedPrivacyButton() {
        onPrivacyButtonTapped?()
    }
}

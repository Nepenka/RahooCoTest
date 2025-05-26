//
//  SettingManager.swift
//  RahooCoTestApp
//
//  Created by Владислав Перелыгин on 26/05/2025.
//

import Foundation


final class SettingsManager {
    static let shared = SettingsManager()
    
    private let soundKey = "soundEnabled"
    private let vibrationKey = "vibrationEnabled"
    
    private init() {
        
        if UserDefaults.standard.object(forKey: soundKey) == nil {
            UserDefaults.standard.set(true, forKey: soundKey)
        }
        if UserDefaults.standard.object(forKey: vibrationKey) == nil {
            UserDefaults.standard.set(true, forKey: vibrationKey)
        }
    }
    
    var isSoundEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: soundKey) }
        set { UserDefaults.standard.set(newValue, forKey: soundKey) }
    }
    
    var isVibrationEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: vibrationKey) }
        set { UserDefaults.standard.set(newValue, forKey: vibrationKey) }
    }
}

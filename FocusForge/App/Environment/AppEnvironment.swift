//
//  AppEnvironment.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 20.05.2025.
//

import Foundation

@Observable
final class AppEnvironment {
    
    let settingsStore: SettingsStore
    let audioManager: AudioManager
    
    init(
        settingsStore: SettingsStore = .init(),
        audioManager: AudioManager
    ) {
        self.settingsStore = settingsStore
        self.audioManager = audioManager
    }
}

extension AppEnvironment {
    static func live() -> AppEnvironment {
        let settingsStore = SettingsStore()
        let audioManager = AudioManager(settingsStore: settingsStore)
        return AppEnvironment(
            settingsStore: settingsStore,
            audioManager: audioManager
        )
    }
}

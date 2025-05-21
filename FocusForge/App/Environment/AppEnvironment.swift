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
    let windowManager: WindowManager
    
    init(
        settingsStore: SettingsStore = .init(),
        audioManager: AudioManager,
        windowManager: WindowManager
    ) {
        self.settingsStore = settingsStore
        self.audioManager = audioManager
        self.windowManager = windowManager
    }
}

extension AppEnvironment {
    static func live() -> AppEnvironment {
        let settingsStore = SettingsStore()
        let audioManager = AudioManager(settingsStore: settingsStore)
        let windowManager = WindowManager()
        return AppEnvironment(
            settingsStore: settingsStore,
            audioManager: audioManager,
            windowManager: windowManager
        )
    }
}

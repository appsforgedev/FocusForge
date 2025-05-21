//
//  AppEnvironment.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 20.05.2025.
//

import Foundation
import SwiftData

@Observable
final class AppEnvironment {
    
    let settingsStore: SettingsStore
    let audioManager: AudioManager
    let windowManager: WindowManager
    let modelContext: ModelContext
    
    init(
        settingsStore: SettingsStore = .init(),
        audioManager: AudioManager,
        windowManager: WindowManager,
        modelContext: ModelContext
    ) {
        self.settingsStore = settingsStore
        self.audioManager = audioManager
        self.windowManager = windowManager
        self.modelContext = modelContext
    }
}

extension AppEnvironment {
    static func live(context: ModelContext) -> AppEnvironment {
        let settingsStore = SettingsStore()
        let audioManager = AudioManager(settingsStore: settingsStore)
        let windowManager = WindowManager()
        return .init(
            settingsStore: settingsStore,
            audioManager: audioManager,
            windowManager: windowManager,
            modelContext: context
        )
    }
}

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
    let dataManager: DataManager
    
    init(
        settingsStore: SettingsStore = .init(),
        audioManager: AudioManager,
        windowManager: WindowManager,
        dataManager: DataManager
    ) {
        self.settingsStore = settingsStore
        self.audioManager = audioManager
        self.windowManager = windowManager
        self.dataManager = dataManager
    }
}

extension AppEnvironment {
    static func live(context: ModelContext) -> AppEnvironment {
        let settingsStore = SettingsStore()
        let audioManager = AudioManager(settingsStore: settingsStore)
        let dataManager = DataManager(modelContext: context)
        let windowManager = WindowManager(modelContext: context)
        
        return .init(
            settingsStore: settingsStore,
            audioManager: audioManager,
            windowManager: windowManager,
            dataManager: dataManager
        )
    }
    
    static func preview() -> AppEnvironment {
        let settingsStore = SettingsStore()
        
        let audioManager = AudioManager(settingsStore: settingsStore)
        let windowManager = WindowManager(modelContext: .preview)
        let dataManager = DataManager(modelContext: .preview)
        
        return .init(
            settingsStore: settingsStore,
            audioManager: audioManager,
            windowManager: windowManager,
            dataManager: dataManager
        )
    }
}

extension AppEnvironment {
    var context: ModelContext { dataManager.modelContext }
    var settings: SettingsStore { settingsStore }
    var sound: AudioManager { audioManager }
    var windows: WindowManager { windowManager }
}

extension ModelContext {
    static var preview: ModelContext {
        let schema = Schema([SessionEntity.self, CycleEntity.self])
        let container = try! ModelContainer(
            for: schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }
}

//
//  SettingsStore.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import Foundation
import Combine

final class SettingsStore: ObservableObject {
    
    static let shared = SettingsStore()
    
    @Published var settings: AppSettings {
        didSet {
            save()
        }
    }

    private static let defaultsKey = "AppSettings"

    init() {
        self.settings = Self.loadSettings()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: Self.defaultsKey)
        }
    }
    
    private static func loadSettings() -> AppSettings {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let saved = try? JSONDecoder().decode(AppSettings.self, from: data) {
            return saved
        } else {
            return AppSettings()
        }
    }
}

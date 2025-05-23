//
//  SettingsStore.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import Foundation
import SwiftUI

@Observable
final class SettingsStore {
    
    /// Объект с настройками, который можно биндить из SwiftUI
    var settings: AppSettings

    @ObservationIgnored
    private let defaults: UserDefaults

    private static let defaultsKey = "AppSettings"

    /// Вычисляемые свойства, например для удобного доступа
    var isSoundEnabled: Bool {
        settings.isSoundEnabled
    }
    
    var isLongBreakFinish: Bool {
        settings.isLongBreakFinish
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.settings = Self.loadSettings(from: defaults)
    }

    /// Сохраняем изменения, когда `settings` меняются
    nonisolated func settingsDidChange() {
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: Self.defaultsKey)
    }

    private static func loadSettings(from defaults: UserDefaults) -> AppSettings {
        guard
            let data = defaults.data(forKey: defaultsKey),
            let saved = try? JSONDecoder().decode(AppSettings.self, from: data)
        else {
            return AppSettings()
        }

        return saved
    }
    
    func binding<Value>(for keyPath: WritableKeyPath<AppSettings, Value>) -> Binding<Value> {
        Binding(
            get: { self.settings[keyPath: keyPath] },
            set: {
                self.settings[keyPath: keyPath] = $0
                self.save()
            }
        )
    }
}

//
//  AppSettings.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import Foundation

final class AppSettings: Codable {
    
    var workDuration: TimeInterval = 25
    var shortBreakDuration: TimeInterval = 5
    var longBreakDuration: TimeInterval = 15
    var sessionsBeforeLongBreak: Int = 4
    
    var isSoundEnabled: Bool = true
    var isLongBreakFinish: Bool = false
}

extension AppSettings {
    /// Длительность фокус-сессии в секундах.
    var workDurationValue: TimeInterval {
        get { workDuration * 60 }
        set { workDuration = newValue / 60 }
    }

    /// Длительность короткого перерыва в секундах.
    var shortBreakDurationValue: TimeInterval {
        get { shortBreakDuration * 60 }
        set { shortBreakDuration = newValue / 60 }
    }

    /// Длительность длинного перерыва в секундах.
    var longBreakDurationValue: TimeInterval {
        get { longBreakDuration * 60 }
        set { longBreakDuration = newValue / 60 }
    }
}

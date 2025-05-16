//
//  AppSettings.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import Foundation

struct AppSettings: Codable, Equatable {
    var workDuration: TimeInterval = 25
    
    var workDurationValue: TimeInterval {
        get { workDuration * 60 }
        set { workDuration = newValue }
    }
    var shortBreakDuration: TimeInterval = 5
    
    var shortBreakDurationValue: TimeInterval {
        get { shortBreakDuration * 60 }
        set { shortBreakDuration = newValue }
    }
    
    var longBreakDuration: TimeInterval = 15
    
    var longBreakDurationValue: TimeInterval {
        get { longBreakDuration * 60 }
        set { longBreakDuration = newValue }
    }
    
    var sessionsBeforeLongBreak: Double = 4
    
    var isSoundEnabled: Bool = true 
}

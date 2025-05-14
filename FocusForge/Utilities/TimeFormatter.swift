//
//  TimeFormatter.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import Foundation

struct TimeFormatter {
    static func string(from timeInterval: TimeInterval) -> String {
        let totalSeconds = Int(timeInterval)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

//
//  StringExtensions.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 07.06.2025.
//

import Foundation

extension String {
    static func formatedTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


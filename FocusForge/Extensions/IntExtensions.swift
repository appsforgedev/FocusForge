//
//  IntExtensions.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 07.06.2025.
//

import Foundation

extension Int {
    
    var formatedToTime: String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

//
//  TimerButton.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 05.06.2025.
//


import SwiftUI

enum TimerButton {
    static func play(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "play.fill")
        }
        .buttonStyle(
            ForgeButtonStyles.TimerControlButtonStyle(tintColor: .buttonPrimaryText, isProminent: true)
        )
    }

    static func pause(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "pause.fill")
        }
        .buttonStyle(
            ForgeButtonStyles.TimerControlButtonStyle(tintColor: .yellow, isProminent: true)
        )
    }

    static func reset(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "gobackward")
        }
        .buttonStyle(
            ForgeButtonStyles.TimerControlButtonStyle(tintColor: .accentSecondary)
        )
    }

    static func skip(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "forward.frame")
        }
        .buttonStyle(
            ForgeButtonStyles.TimerControlButtonStyle(tintColor: .accentSecondary)
        )
    }
}

//
//  MainScreenViewModel.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//

import Foundation

final class MainScreenViewModel: ObservableObject {
    
    enum Screen {
        case timer
        case settings
    }

    @Published var currentScreen: Screen = .timer

    func showTimer() {
        currentScreen = .timer
    }

    func showSettings() {
        currentScreen = .settings
    }
}


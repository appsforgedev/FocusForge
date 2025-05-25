//
//  AppState.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//

import Foundation
import AppKit

@Observable
final class AppState {
    
    enum Screen {
        case timer
        case settings
    }
    
    let env: AppEnvironment
    
    var timerState: TimerState
    var currentScreen: Screen = .timer

    private(set) var statusBarController: StatusBarController!

    init(environment: AppEnvironment) {
        self.env = environment
        self.timerState = .init(environment: environment)
        let mainView = MainView().environment(self)
        
        self.statusBarController = StatusBarController(mainView: mainView)
        observeStatusBarUpdates()
    }
    
    func showSettings() {
        currentScreen = .settings
    }

    func showTimer() {
        currentScreen = .timer
    }

    func observeStatusBarUpdates() {
        Task {
            while true {
                withObservationTracking {
                    let duration = timerState.duration(for: timerState.currentSession)
                    let progress = timerState.timeRemaining / max(duration, 1)
                    let formattedTime = TimeFormatter.string(from: timerState.displayTime)
                    
                    // Обновляем UI на главном потоке
                    Task { @MainActor in
                        statusBarController.updateStatus(
                            session: timerState.currentSession,
                            time: formattedTime,
                            progress: progress,
                            isRunning: timerState.isRunning
                        )
                    }
                } onChange: { }
                
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 секунды
            }
        }
    }
}

// MARK: App terminate section

extension AppState {
    func terminateApplication() {

        timerState.forceFinalizeSession()

        // 3. Сохранить данные SwiftData
        do {
            try env.context.save()
        } catch {
            print("⚠️ Error saving data context: \(error)")
        }

        // 4. Завершить приложение
        NSApplication.shared.terminate(nil)
    }
}

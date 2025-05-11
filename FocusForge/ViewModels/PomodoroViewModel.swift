//
//  PomodoroViewModel.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 11.05.2025.
//


import Foundation

enum SessionType {
    case idle
    case focus
    case rest
    case pause
    
    var title: String {
        switch self {
        case .idle:
            return "Idle"
        case .focus:
            return "Focus"
        case .rest:
            return "Rest"
        case .pause:
            return "Paused"
        }
    }
}

class PomodoroViewModel: ObservableObject {
    @Published var displayTime: String = "25:00"
    @Published var isRunning = false
    @Published var currentSession: SessionType = .idle

    private var timer: Timer?
    private var totalSeconds = 25 * 60

    func toggleTimer() {
        isRunning.toggle()
        if isRunning {
            startTimer()
            currentSession = .focus
        } else {
            timer?.invalidate()
            currentSession = .pause
        }
    }

    func reset() {
        timer?.invalidate()
        isRunning = false
        currentSession = .idle
        totalSeconds = 25 * 60
        updateDisplay()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.totalSeconds -= 1
            if self.totalSeconds <= 0 {
                self.reset()
            } else {
                self.updateDisplay()
            }
        }
    }

    private func updateDisplay() {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        displayTime = String(format: "%02d:%02d", minutes, seconds)
    }
}

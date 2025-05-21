//
//  TimerState.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 20.05.2025.
//

import Foundation

@Observable
final class TimerState {
    
    enum TimerStatus: Equatable {
        case idle
        case running
        case paused(remaining: TimeInterval)
    }
    
    private let environment: AppEnvironment
    
    var settings: AppSettings {
        environment.settingsStore.settings
    }

    var timeRemaining: TimeInterval = 0
    var currentSession: PomodoroSession = .focus
    var nextSession: PomodoroSession? = nil
    var status: TimerStatus = .idle
    
    var isRunning: Bool {
        status != .idle
    }

    let interval: TimeInterval = 1
    private var timerTask: Task<Void, Never>?

    private var completedFocusSessions = 0
    private var sessionsBeforeLongBreak = 4
    
    var displayTime: TimeInterval {
        switch status {
        case .running:
            return timeRemaining
        case .paused(let remaining):
            return remaining
        case .idle:
            return duration(for: currentSession)
        }
    }

    init(environment: AppEnvironment) {
        self.environment = environment
        self.sessionsBeforeLongBreak = settings.sessionsBeforeLongBreak
        self.timeRemaining = duration(for: currentSession)
    }

    // MARK: - Timer Control

    func start(from initialTime: TimeInterval? = nil) {
        guard case .running = status else {
            environment.audioManager.play(.startFocus)
            let initialTime = initialTime ?? duration(for: currentSession)
            start(from: initialTime)
            return
        }
    }

    private func start(from initialTime: TimeInterval) {
        stop()
        timeRemaining = initialTime
        status = .running
        sessionsBeforeLongBreak = settings.sessionsBeforeLongBreak
        nextSession = getNextSession()

        timerTask = Task {
            while timeRemaining > 0 && !Task.isCancelled {
                try? await Task.sleep(for: .seconds(interval))
                if Task.isCancelled { break }

                await MainActor.run {
                    timeRemaining -= interval

                    if timeRemaining <= 5 && timeRemaining > 0 {
                        environment.audioManager.play(.tick)
                    }

                    if timeRemaining <= 0 {
                        handleSessionCompletion()
                    }
                }
            }
        }
    }

    func pause() {
        guard case .running = status else { return }
        
        environment.audioManager.play(.pause)
        stop()
        status = .paused(remaining: timeRemaining)
    }

    func reset() {
        stop()
        environment.audioManager.play(.reset)
        currentSession = .focus
        timeRemaining = duration(for: currentSession)
        status = .idle
        completedFocusSessions = 0
        nextSession = nil
    }

    private func stop() {
        timerTask?.cancel()
        timerTask = nil
    }

    // MARK: - Session Completion

    private func handleSessionCompletion() {
        switch currentSession {
        case .focus:
            environment.audioManager.play(.endFocus)
            completedFocusSessions += 1

            currentSession = completedFocusSessions % sessionsBeforeLongBreak == 0
                ? .longBreak
                : .shortBreak

        case .shortBreak:
            environment.audioManager.play(.endShortBreak)
            currentSession = .focus
        case .longBreak:
            environment.audioManager.play(.endLongBreak)
            currentSession = .focus
        }

        timeRemaining = duration(for: currentSession)
        start(from: timeRemaining)
    }
    
    private func getNextSession() -> PomodoroSession {
        switch currentSession {
        case .focus:
            return completedFocusSessions % sessionsBeforeLongBreak == 0
                ? .shortBreak
                : .longBreak
        case .longBreak, .shortBreak:
            return .focus
        }
    }

    // MARK: - Helpers

    func duration(for session: PomodoroSession) -> TimeInterval {
        switch session {
        case .focus: return settings.workDurationValue
        case .shortBreak: return settings.shortBreakDurationValue
        case .longBreak: return settings.longBreakDurationValue
        }
    }

    func forceTimer() {
        timeRemaining = duration(for: currentSession) - (duration(for: currentSession) - 5)
    }
}

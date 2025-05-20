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
    private var observation: Observation?

    var timeRemaining: TimeInterval = 0
    var currentSession: PomodoroSession = .focus
    var status: TimerStatus = .idle
    var isRunning: Bool {
        status == .running
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
        self.sessionsBeforeLongBreak = environment.settingsStore.settings.sessionsBeforeLongBreak
        self.timeRemaining = duration(for: currentSession)
        
        observeSettings()
    }
    
    private func observeSettings() {
        
        withObservationTracking(environment.settingsStore) { settingsStore in
            if case .idle = status {
                timeRemaining = duration(for: currentSession)
            }
            
            sessionsBeforeLongBreak = settingsStore.settings.sessionsBeforeLongBreak
        }
        
        observation = Observation {
            let _ = settingsStore.settings.sessionsBeforeLongBreak
            
            // при любом изменении settings вызывается этот блок
            if case .idle = status {
                timeRemaining = duration(for: currentSession)
            }
            
            sessionsBeforeLongBreak = settingsStore.settings.sessionsBeforeLongBreak
        }
    }

    // MARK: - Timer Control

    func start() {
        guard case .running = status else {
            environment.audioManager.play(.startFocus)
            start(from: timeRemaining)
            return
        }
    }

    private func start(from initialTime: TimeInterval) {
        stop()
        timeRemaining = initialTime
        status = .running

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
        currentSession = .focus
        timeRemaining = duration(for: currentSession)
        status = .idle
        completedFocusSessions = 0
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

        case .shortBreak, .longBreak:
            environment.audioManager.play(.startFocus)
            currentSession = .focus
        }

        timeRemaining = duration(for: currentSession)
        start(from: timeRemaining)
    }

    // MARK: - Helpers

    func duration(for session: PomodoroSession) -> TimeInterval {
        switch session {
        case .focus: return environment.settingsStore.settings.workDurationValue
        case .shortBreak: return environment.settingsStore.settings.shortBreakDurationValue
        case .longBreak: return environment.settingsStore.settings.longBreakDurationValue
        }
    }

    func forceTimer() {
        timeRemaining = duration(for: currentSession) - (duration(for: currentSession) - 5)
    }
}

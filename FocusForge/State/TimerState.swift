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
    
    var currentDuration: TimeInterval {
        duration(for: currentSession)
    }
    
    private var sessionStartDate: Date?
    
    var isRunning: Bool {
        status != .idle
    }
    
    var nextSessionTitle: String? {
        if
            currentSession == .longBreak,
            environment.settings.isLongBreakFinish
        {
            return "End Cycle"
        }
        return nextSession?.title
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
            sessionStartDate = Date()
            let initialTime = initialTime ?? duration(for: currentSession)
            environment.audioManager.play(.startFocus)
            start(from: initialTime)
            return
        }
    }

    private func start(from initialTime: TimeInterval) {
        stopTimer()
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
        stopTimer()
        status = .paused(remaining: timeRemaining)
    }
    
    func finalize() {
        environment.audioManager.play(.reset)
        forceFinalizeSession()
        reset()
    }

    func reset() {
        currentSession = .focus
        timeRemaining = duration(for: currentSession)
        status = .idle
        completedFocusSessions = 0
        nextSession = nil
    }

    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    // MARK: - Session Completion

    private func handleSessionCompletion() {
        guard let sessionStartDate else {
            print("⚠️ Session is not started yet")
            return
        }
        recordSession(
            startTime: sessionStartDate,
            currentSession: currentSession
        )
    
        self.sessionStartDate = nil
        
        switch currentSession {
        case .focus:
            environment.audioManager.play(.endFocus)
            completedFocusSessions += 1
            currentSession = completedFocusSessions % sessionsBeforeLongBreak == 0
                ? .longBreak
                : .shortBreak

        case .shortBreak:
            currentSession = .focus
        case .longBreak:
            environment.audioManager.play(.endLongBreak)
            currentSession = .focus
            environment.dataManager.finishCurrentCycle()
            if environment.settingsStore.isLongBreakFinish {
                stopTimer()
                reset()
                return
            }
        }

        timeRemaining = duration(for: currentSession)
        self.sessionStartDate = Date()
        if currentSession == .focus {
            environment.audioManager.play(.startFocus)
        }
        start(from: timeRemaining)
    }
    
    func interruptSession() {
        guard let sessionStartDate else { return }
        
        recordSession(
            startTime: sessionStartDate,
            currentSession: currentSession,
            isInterrupted: true
        )
        
        self.sessionStartDate = nil
    }
    
    func forceFinalizeSession() {
        guard isRunning, let sessionStartDate else { return }

        recordSession(
            startTime: sessionStartDate,
            currentSession: currentSession,
            isInterrupted: true
        )
        
        stopTimer()
    }
    
    private func recordSession(
        startTime: Date,
        currentSession: PomodoroSession,
        isInterrupted: Bool = false
    ) {
        environment.dataManager.recordSession(
            type: currentSession,
            start: startTime,
            end: Date(),
            interrupted: isInterrupted
        )
    }

    
    private func getNextSession() -> PomodoroSession {
        switch currentSession {
        case .focus:
            let nextCompleted = completedFocusSessions + 1
            return (nextCompleted % sessionsBeforeLongBreak == 0)
                ? .longBreak
                : .shortBreak
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

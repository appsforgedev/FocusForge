//
//  TimerViewModel.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 11.05.2025.
//


import Foundation
import Combine

class TimerViewModel: ObservableObject {

    @Published var timeRemaining: TimeInterval = 1500
    @Published var formattedTime: String = "25:00"
    @Published var isRunning: Bool = false
    @Published var currentSession: PomodoroSession = .focus
    @Published var currentSessionDuration: TimeInterval = 1500
    @Published var currentProgress: Double = 0

    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var settingsStore: SettingsStore
    
    private var completedFocusSessions = 0
    private var sessionsBeforeLongBreak = 4
    
    private var settings: AppSettings {
        settingsStore.settings
    }
    
    internal init(
        settingsStore: SettingsStore
    ) {
        self.settingsStore = settingsStore
        self.sessionsBeforeLongBreak = Int(settings.sessionsBeforeLongBreak)
        self.timeRemaining = duration(for: currentSession)
        self.currentSessionDuration = duration(for: currentSession)
        setupBindings()
    }

    func forceTimer() {
        timeRemaining = duration(for: currentSession) - (duration(for: currentSession) - 5)
    }
    
    func forceHalfTimer() {
        timeRemaining = duration(for: currentSession) - (duration(for: currentSession) - (duration(for: currentSession) / 2))
    }

    func toggleTimer() {
        isRunning ? pause() : start()
    }

    func start() {
        isRunning = true
        if currentSession == .focus {
            AudioManager.shared.play(.startFocus)
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.tick()
        }
    }

    func pause() {
        isRunning = false
        AudioManager.shared.play(.pause)
        timer?.invalidate()
    }

    func reset() {
        pause()
        
        timeRemaining = duration(for: currentSession)
        currentSessionDuration = duration(for: currentSession)
        updateDisplay()
    }

    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            if timeRemaining < 5 {
                AudioManager.shared.play(.tick)
            }
            updateDisplay()
        } else {
            pause()
            handleSessionCompletion()
        }
    }
    
    private func handleSessionCompletion() {
        switch currentSession {
        case .focus:
            AudioManager.shared.play(.endFocus)
            completedFocusSessions += 1
            if completedFocusSessions % sessionsBeforeLongBreak == 0 {
                currentSession = .longBreak
            } else {
                currentSession = .shortBreak
            }
        case .shortBreak, .longBreak:
            currentSession = .focus
        }
        timeRemaining = duration(for: currentSession)
        currentSessionDuration = duration(for: currentSession)
        start()
    }
    
    private func duration(for session: PomodoroSession) -> TimeInterval {
        switch session {
        case .focus: return settings.workDurationValue
        case .shortBreak: return settings.shortBreakDurationValue
        case .longBreak: return settings.longBreakDurationValue
        }
    }

    private func updateDisplay() {
        formattedTime = TimeFormatter.string(from: Double(timeRemaining))
    }
    
    private func setupBindings() {
        
        Publishers.CombineLatest(
            $currentSessionDuration,
            $timeRemaining
        )
        .receive(on: RunLoop.main)
        .map { sessionDuration, timeRemaining in
            timeRemaining / sessionDuration
        }
        .assign(to: \.currentProgress, on: self)
        .store(in: &cancellables)
        
        settingsStore.$settings
            .map(\.workDurationValue)
            .assign(to: \.timeRemaining, on: self)
            .store(in: &cancellables)
        
        settingsStore.$settings
            .map(\.workDurationValue)
            .assign(to: \.currentSessionDuration, on: self)
            .store(in: &cancellables)
        
        $timeRemaining
            .map { TimeFormatter.string(from: $0) }
            .assign(to: \.formattedTime, on: self)
            .store(in: &cancellables)
    }
}


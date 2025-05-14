//
//  AppState.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//

import Foundation
import AppKit
import Combine

final class AppState: ObservableObject {
    let settingsStore = SettingsStore()
    let timerViewModel: TimerViewModel
    let mainViewModel: MainScreenViewModel
    
    private(set) var statusBarController: StatusBarController!
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.timerViewModel = TimerViewModel(settingsStore: settingsStore)
        self.mainViewModel = MainScreenViewModel()

        let mainView = MainView(viewModel: mainViewModel)
            .environmentObject(self)

        self.statusBarController = StatusBarController(mainView: mainView)

        setupBindings()
    }

    private func setupBindings() {
        Publishers.CombineLatest3(
            timerViewModel.$timeRemaining,
            timerViewModel.$currentSession,
            timerViewModel.$currentSessionDuration
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] time, session, sessionDuration in
            guard let self else { return }
            print("time: \(time), session: \(session), sessionDuration: \(sessionDuration)") // Debug output
            let progress = time / sessionDuration
            self.statusBarController.updateStatus(
                session: session,
                time: TimeFormatter.string(from: time),
                progress: progress
            )
        }
        .store(in: &cancellables)
    }
}

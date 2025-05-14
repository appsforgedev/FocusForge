//
//  MainView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 12) {
            switch viewModel.currentScreen {
            case .timer:
                VStack {
                    Spacer()
                    TimerView(viewModel: appState.timerViewModel)
                    Spacer()
                    Button("Settings") {
                        viewModel.showSettings()
                    }
                    .padding()
                }
            case .settings:
                VStack {
                    Spacer()
                    SettingsView(
                        settingsStore: appState.settingsStore,
                        timerIsRunning: appState.timerViewModel.isRunning
                    )
                    Spacer()
                    Button("Back") {
                        viewModel.showTimer()
                    }
                    .padding()

                }
            }
        }
        .frame(width: 280, height: 280)
    }
}

//#Preview {
//    MainView(viewModel: MainScreenViewModel()).environmentObject(AppState())
//}

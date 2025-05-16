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
        VStack(spacing: 4) {
            switch viewModel.currentScreen {
            case .timer:
                VStack {
                    Spacer()
                    TimerView(viewModel: appState.timerViewModel)
                    Spacer()
                    Button("Settings") {
                        viewModel.showSettings()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Minimal())
                    .padding(.bottom, 8)
                }
            case .settings:
                VStack {
                    Spacer()
                    SettingsView(
                        settingsStore: SettingsStore.shared,
                        timerIsRunning: appState.timerViewModel.isRunning
                    )
                    Spacer()
                    Button("Back") {
                        viewModel.showTimer()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Minimal())
                    .padding(.bottom, 8)
                }
            }
        }
        .frame(width: 280, height: 260)
    }
}

//#Preview {
//    MainView(viewModel: MainScreenViewModel()).environmentObject(AppState())
//}

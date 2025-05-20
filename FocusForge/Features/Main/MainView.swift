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
        ZStack(alignment: .topTrailing) {
            VStack {
                Spacer()
                switch viewModel.currentScreen {
                case .timer:
                    TimerView(viewModel: appState.timerViewModel)
                    Spacer()
                    Button("Settings") {
                        AudioManager.shared.play(.click)
                        viewModel.showSettings()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Minimal())
                    .padding(.bottom, 8)
                case .settings:
                    Spacer()
                    SettingsView(
                        settingsStore: SettingsStore.shared,
                        timerIsRunning: appState.timerViewModel.isRunning
                    )
                    Spacer()
                    Button("Back") {
                        AudioManager.shared.play(.click)
                        viewModel.showTimer()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Minimal())
                    .padding(.bottom, 8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            switch viewModel.currentScreen {
            case .timer:
                VStack(spacing: 8) {
                    Spacer()
                    Button {
                        SettingsStore.shared.settings.isSoundEnabled.toggle()
                    } label: {
                        Image(systemName: SettingsStore.shared.settings.isSoundEnabled
                              ? "speaker.wave.2.circle"
                              : "speaker.slash.circle")
                        .font(.system(size: 22))
                    }
                    
                    Button {
                        AudioManager.shared.play(.click)
                    } label: {
                        Image(systemName: "list.bullet.circle")
                            .font(.system(size: 22))
                    }
                    Spacer()
                }
                .padding(.trailing, 16)
            case .settings:
                EmptyView()
            }
        }
    }
}

//#Preview {
//    MainView(viewModel: MainScreenViewModel()).environmentObject(AppState())
//}

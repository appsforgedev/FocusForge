//
//  MainView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import SwiftUI

struct MainView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Spacer()
                switch appState.currentScreen {
                case .timer:
                    TimerView(timerState: appState.timerState)
                    Spacer()
                    Button("Settings") {
                        appState.environment.audioManager.play(.click)
                        appState.showSettings()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Minimal())
                    .padding(.bottom, 8)
                case .settings:
                    Spacer()
                    SettingsView(timerIsRunning: appState.timerState.isRunning)
                        .environment(appState.environment)
                    Spacer()
                    Button("Back") {
                        appState.environment.audioManager.play(.click)
                        appState.showTimer()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Minimal())
                    .contentShape(Rectangle())
                    .padding(.bottom, 8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            switch appState.currentScreen {
            case .timer:
                VStack(spacing: 8) {
                    Spacer()
                    Button {
                        appState.environment.settingsStore.settings.isSoundEnabled.toggle()
                    } label: {
                        Image(systemName: appState.environment.settingsStore.isSoundEnabled
                              ? "speaker.wave.2.circle"
                              : "speaker.slash.circle")
                        .font(.system(size: 22))
                    }
                    .contentShape(Rectangle())
                    
                    Button {
                        appState.environment.audioManager.play(.click)
                    } label: {
                        Image(systemName: "list.bullet.circle")
                            .font(.system(size: 22))
                    }
                    .contentShape(Rectangle())
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

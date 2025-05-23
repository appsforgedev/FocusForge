//
//  MainView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                switch appState.currentScreen {
                case .timer:
                    Spacer()
                    TimerView(timerState: appState.timerState)
                    Spacer()
                    Button("Settings") {
                        appState.env.audioManager.play(.click)
                        appState.showSettings()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Minimal())
                    .padding(.bottom, 8)
                case .settings:
                    Spacer()
                    SettingsView(timerIsRunning: appState.timerState.isRunning)
                        .environment(appState.env)
                    Spacer()
                    Button("Back") {
                        appState.env.audioManager.play(.click)
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
                    ToggleButton(
                        systemImageOn: "speaker.square",
                        systemImageOff: "speaker.square.fill",
                        isOn: appState.env.settingsStore.binding(for: \.isSoundEnabled)
                    )
                    
                    Button {
                        appState.env.audioManager.play(.click)
                        appState.env.windowManager.showHistory(
                            modelContext: appState.env.context
                        )
                    } label: {
                        Image(systemName: "h.square")
                            .font(.system(size: 28))
                    }
                    
                    Button {
                        appState.env.dataManager.clearDataBase()
                    } label: {
                        Image(systemName: "trash.slash.square")
                            .font(.system(size: 28))
                    }
                    Button {
                        appState.terminateApplication()
                    } label: {
                        Image(systemName: "xmark.square")
                            .font(.system(size: 28))
                    }
                    Spacer()
                }
                .buttonStyle(.plain)
                .padding(.trailing, 16)
            case .settings:
                EmptyView()
                
            }
        }
    }
}

struct ToggleButton: View {
    let systemImageOn: String
    let systemImageOff: String
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Image(
                systemName: isOn ? systemImageOn : systemImageOff
            )
            .foregroundStyle(isOn ? .primary : .secondary)
            .font(.system(size: 28))
        }
        .contentShape(Rectangle())
    }
}

//#Preview {
//    MainView(viewModel: MainScreenViewModel()).environmentObject(AppState())
//}

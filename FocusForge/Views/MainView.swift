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
//    @Environment(\.openWindow) private var openWindow
    
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
                    .buttonStyle(ForgeButtonStyles.Minimal())
                    .padding(.bottom)
                case .settings:
                    Spacer()
                    SettingsView(timerIsRunning: appState.timerState.isRunning)
                        .environment(appState.env)
                    Spacer()
                    Button("Back") {
                        appState.env.audioManager.play(.click)
                        appState.showTimer()
                    }
                    .buttonStyle(ForgeButtonStyles.Minimal())
                    .padding(.bottom)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.backgroundColor)
                .shadow(color: .black.opacity(0.45), radius: 5, x: 5, y: 5)
        )
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
                        appState.env.windowManager.toggleHistory()
                    } label: {
                        Image(systemName: "h.square")
                            .font(.system(size: 28))
                            .foregroundStyle(Color.buttonSecondary)
                    }
                    
                    Button {
                        appState.env.windowManager.showAlert(
                            message: "Exit?",
                            buttonTitle: "Ok",
                            onConfirm: {
                                appState.terminateApplication()
                            }) {
                                print("On cancel")
                            }
                    } label: {
                        Image(systemName: "xmark.square")
                            .font(.system(size: 28))
                            .foregroundStyle(Color.buttonSecondary)
                    }
                    #if DEBUG
                    Group {
                        Button {
                            appState.timerState.forceTimer()
                        } label: {
                            Image(systemName: "arrow.clockwise.square")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.buttonSecondary)
                        }
                        Button {
                            appState.env.dataManager.clearDataBase()
                        } label: {
                            Image(systemName: "trash.slash.square")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.buttonSecondary)
                        }
                    }
                    .background(.brown)
                    #endif
                    Spacer()
                }
                .buttonStyle(.plain)
                .padding(.trailing, 16)
            case .settings:
                EmptyView()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
            .foregroundStyle(isOn ? Color.buttonSecondary : .accentSecondary)
            .font(.system(size: 28))
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}

#Preview {
    MainView().environment(AppState.init(environment: .preview()))
        .frame(width: 300, height: 280)
}

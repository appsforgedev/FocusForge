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
        ZStack {
            VStack {
                switch appState.currentScreen {
                case .timer:
                    Spacer()
                    TimerView(timerState: appState.timerState)
                    Spacer()
                    Button {
                        appState.env.audioManager.play(.click)
                        appState.env.windowManager.toggleHistory()
                    } label: {
                        Text("History")
                    }
                    .buttonStyle(ForgeButtonStyles.Minimal())
                    .padding(.bottom, 8)

                case .settings:
                    Spacer()
                    VStack(alignment: .center) {
                        HStack {
                            BackButton
                            Text("Settings")
                                .font(.forgeTitle)
                                .foregroundStyle(Color.textPrimary)
                            Spacer()
                        }
                        .padding(.top, 8)
                        .padding(.leading, 16)
                        Spacer()
                        SettingsView(timerIsRunning: appState.timerState.isRunning)
                            .environment(appState.env)
                        Spacer()
                    }
                    Spacer()
                }
            }
            // Кнопка закрытия — в левом верхнем углу
            if appState.currentScreen == .timer {
                VStack {
                    HStack {
                        CloseButton
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }

                // Кнопка настроек — в правом нижнем углу
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        SettingsButton
                            .padding()
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        SoundButton(
                            isOn: appState.env.settingsStore.binding(for: \.isSoundEnabled)
                        )
                        .padding()
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundColor)
                .shadow(color: .black.opacity(0.45), radius: 5, x: 5, y: 5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .debugOverlay {
            switch appState.currentScreen {
            case .timer:
                VStack(spacing: 8) {
                    Spacer()
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
                    .border(.red)
                    Spacer()
                }
                .buttonStyle(.plain)
                .padding(.trailing, 16)
            case .settings:
                EmptyView()
            }
        }
    }
    
    var BackButton: some View {
        Button {
            appState.env.audioManager.play(.click)
            appState.showTimer()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 20))
                .foregroundStyle(.textPrimary.opacity(0.8))
                .frame(width: 28, height: 28)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    var CloseButton: some View {
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
            Image(systemName: "xmark")
                .font(.system(size: 20))
                .foregroundStyle(.textPrimary.opacity(0.7))
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    var SettingsButton: some View {
        Button {
            appState.env.audioManager.play(.click)
            appState.showSettings()
        } label: {
            Image(systemName: "gearshape")
                .font(.system(size: 20))
                .foregroundStyle(.textPrimary.opacity(0.7))
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct SoundButton: View {
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            ZStack {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.textPrimary.opacity(0.7))
                if !isOn {
                    Capsule()
                        .foregroundStyle(.textPrimary)
                        .frame(width: 28, height: 3)
                        .rotationEffect(.degrees(-45))
                        .offset(x: 0, y: 0)
                }
            }
            .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}

#Preview {
    MainView().environment(AppState.init(environment: .preview()))
        .frame(width: 300, height: 280)
}

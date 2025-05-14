//
//  SettingsView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsStore: SettingsStore
    @State var timerIsRunning: Bool

    var body: some View {
        if timerIsRunning {
            VStack {
                Text("It is Running")
                    .font(.title2)
                    .monospaced()
                    .multilineTextAlignment(.center)
                Text("Stop timer for setup")
                    .font(.footnote)
                    .monospaced()
            }
        } else {
            Form {
                Section(header: Text("Durations (minutes)").customHeadline()) {
                    Slider(value: binding(for: \.workDuration), in: 15...90, step: 5) {
                        Text("Work: \(Int(settingsStore.settings.workDuration))")
                    }
                    Slider(value: binding(for: \.shortBreakDuration), in: 5...30, step: 5) {
                        Text("Short Break: \(Int(settingsStore.settings.shortBreakDuration))")
                    }
                    Slider(value: binding(for: \.longBreakDuration), in: 5...60, step: 5) {
                        Text("Long Break: \(Int(settingsStore.settings.longBreakDuration))")
                    }
                    
                }
                Section(header: Text("Session Settings").customHeadline()) {
                    Slider(value: binding(for: \.sessionsBeforeLongBreak), in: 1...10, step: 1) {
                        Text("Before long break: \(Int(settingsStore.settings.sessionsBeforeLongBreak))")
                    }
                }
                
            }
            .padding()
            .frame(width: 280)
            .disabled(timerIsRunning)
        }
    }

    // Универсальный биндинг к AppSettings
    private func binding<Value>(for keyPath: WritableKeyPath<AppSettings, Value>) -> Binding<Value> {
        Binding(
            get: { self.settingsStore.settings[keyPath: keyPath] },
            set: { self.settingsStore.settings[keyPath: keyPath] = $0 }
        )
    }
}

extension Text {
    @ViewBuilder
    public func customHeadline() -> some View {
        self.modifier(SectionHeaderStyle())
    }
}

struct SectionHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.secondary)
    }
}

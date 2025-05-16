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
//                    Slider(value: binding(for: \.workDuration), in: 15...90, step: 5) {
//                        Text("Focus: \(Int(settingsStore.settings.workDuration))")
//                    }
                    CounterView(
                        text: "Focus:",
                        step: 5,
                        count: binding(for: \.workDuration)
                    )
//                    Slider(value: binding(for: \.shortBreakDuration), in: 5...30, step: 5) {
//                        Text("Short Break: \(Int(settingsStore.settings.shortBreakDuration))")
//                    }
                    CounterView(
                        text: "Short Break:",
                        step: 5,
                        count: binding(for: \.shortBreakDuration)
                    )
//                    Slider(value: binding(for: \.longBreakDuration), in: 5...60, step: 5) {
//                        Text("Long Break: \(Int(settingsStore.settings.longBreakDuration))")
//                    }
                    CounterView(
                        text: "Long Break:",
                        step: 5,
                        count: binding(for: \.longBreakDuration)
                    )
                    
                }
                Section(header: Text("Session Settings").customHeadline()) {
//                    Slider(value: binding(for: \.sessionsBeforeLongBreak), in: 1...10, step: 1) {
//                        Text("Before long break: \(Int(settingsStore.settings.sessionsBeforeLongBreak))")
//                    }
                    CounterView(
                        text: "Before long break:",
                        step: 1,
                        count: binding(for: \.sessionsBeforeLongBreak)
                    )
                    ToggleView(text: "Sound ebabled:", isOn: binding(for: \.isSoundEnabled))
//                    Toggle("Sound ebabled", isOn: binding(for: \.isSoundEnabled))
                }
                
            }
            .padding()
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

struct ToggleView: View {
    var text: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(text).customHeadline()
            Spacer()
            Toggle(isOn: $isOn) {
                Text("")
            }
        }
        .padding(.horizontal, 16)
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct CounterView: View {
    var text: String
    var step: TimeInterval
    @Binding var count: TimeInterval
    
    var body: some View {
        HStack {
            Text(text).customHeadline()
            Spacer()
            Text("\(Int(count))")
            Button("+") {
                count += step
            }
            .font(.subheadline)
            Button("-") {
                count -= step
            }
            .font(.subheadline)
        }
        .padding(.horizontal, 16)
        .frame(minWidth: 0, maxWidth: .infinity)
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

//
//  SettingsView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import SwiftUI

struct SettingsView: View {
    @Environment(AppEnvironment.self) private var appEnvironment
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
                    CounterView(
                        text: "Focus:",
                        step: 5,
                        range: 15...90,
                        count: appEnvironment.settingsStore.binding(for: \.workDuration)
                    )
                    CounterView(
                        text: "Short Break:",
                        step: 5,
                        range: 5...30,
                        count: appEnvironment.settingsStore.binding(for: \.shortBreakDuration)
                    )
                    CounterView(
                        text: "Long Break:",
                        step: 5,
                        range: 15...60,
                        count: appEnvironment.settingsStore.binding(for: \.longBreakDuration)
                    )
                    
                }
                Section(header: Text("Session Settings").customHeadline()) {
                    CounterView(
                        text: "Before long break:",
                        step: 1,
                        range: 1...10,
                        count: appEnvironment.settingsStore.binding(for: \.sessionsBeforeLongBreak)
                    )
                    ToggleView(
                        text: "Sound ebabled:",
                        isOn: appEnvironment.settingsStore.binding(for: \.isSoundEnabled)
                    )
                }
                
            }
            .padding()
            .disabled(timerIsRunning)
        }
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

struct CounterView<T: Strideable & Comparable>: View where T.Stride: SignedNumeric & Comparable {
    @Environment(AppEnvironment.self) private var appEnvironment
    var text: String
    var step: T.Stride
    var range: ClosedRange<T>
    
    @Binding var count: T
    
    @State private var plusDisabled: Bool = false
    @State private var minusDisabled: Bool = false
    
    var body: some View {
        HStack {
            Text(text).customHeadline()
            Spacer()
            Text("\(displayValue)")
            Button("+") {
                count = count.advanced(by: step)
                appEnvironment.audioManager.play(.click)
                updateDisabledStates()
            }
            .font(.subheadline)
            .disabled(plusDisabled)
            Button("-") {
                count = count.advanced(by: -step)
                appEnvironment.audioManager.play(.click)
                updateDisabledStates()
            }
            .font(.subheadline)
            .disabled(minusDisabled)
        }
        .padding(.horizontal, 16)
        .frame(minWidth: 0, maxWidth: .infinity)
        .onAppear {
            updateDisabledStates()
        }
    }
    
    private var displayValue: String {
         if let count = count as? TimeInterval {
             return "\(Int(count))" // можно расширить форматирование
         } else {
             return "\(count)"
         }
     }
    
    private func updateDisabledStates() {
        plusDisabled = count.advanced(by: step) > range.upperBound
        minusDisabled = count.advanced(by: -step) < range.lowerBound
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

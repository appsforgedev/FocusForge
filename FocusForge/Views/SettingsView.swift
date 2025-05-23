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
                Text("Session is running, please reset it for configure")
                    .font(.title3)
                    .monospaced()
                    .multilineTextAlignment(.center)
            }
        } else {
            Form {
                Section(header: Text("Durations (minutes)").customHeadlineStyle()) {
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
                Section(header: Text("Session Settings").customHeadlineStyle()) {
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
                    ToggleView(
                        text: "Long break is finish cycle:",
                        isOn: appEnvironment.settingsStore.binding(for: \.isLongBreakFinish)
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
            Text(text).settingsStyle()
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
            Text(text).settingsStyle()
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
    public func customHeadlineStyle() -> some View {
        self.modifier(SectionHeaderStyle())
    }
    
    @ViewBuilder
    public func settingsStyle() -> some View {
        self.modifier(SettingsStyle())
    }
}

struct SectionHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.secondary)
    }
}

struct SettingsStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
    }
}

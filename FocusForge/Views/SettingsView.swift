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
            VStack(spacing: 5) {
                Text("Settings")
                    .font(.headline)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
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
            .padding()
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
            }.toggleStyle(
                CheckboxToggleStyle(
                    fillColor: .buttonSecondary,
                    borderColor: .gray.opacity(0.7),
                    checkmarkColor: .accent,
                    size: 16
                )
            )
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.leading, 16)
        .padding(.trailing, 8)
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
                .foregroundStyle(Color.textPrimary)
            Button {
                count = count.advanced(by: step)
                appEnvironment.audioManager.play(.click)
                updateDisabledStates()
            } label: {
                Text("+")
                    .font(.subheadline)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.buttonPrimaryText)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.buttonSecondary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.gray.opacity(0.7), lineWidth: 1)
                            )
                    )
            }
            .buttonStyle(.plain)
            .disabled(plusDisabled)

            Button {
                count = count.advanced(by: -step)
                appEnvironment.audioManager.play(.click)
                updateDisabledStates()
            } label: {
                Text("-")
                    .font(.subheadline)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.buttonPrimaryText)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.buttonSecondary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.gray.opacity(0.7), lineWidth: 1)
                            )
                    )
            }
            .buttonStyle(.plain)
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
    public func settingsStyle() -> some View {
        self.modifier(SettingsStyle())
    }
}

struct SettingsStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .fontWeight(.medium)
            .foregroundStyle(Color.textPrimary)
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    var fillColor: Color = .green
    var borderColor: Color = .gray
    var checkmarkColor: Color = .white
    var size: CGFloat = 20

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button(action: { configuration.isOn.toggle() }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor, lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(configuration.isOn ? fillColor : .clear)
                        )
                        .frame(width: size, height: size)
                        .contentShape(Rectangle())

                    if configuration.isOn {
                        Image(systemName: "checkmark")
                            .foregroundColor(checkmarkColor)
                            .font(.system(size: size * 0.6, weight: .bold))
                    }
                }
            }
            .buttonStyle(.plain)

            configuration.label
        }
    }
}

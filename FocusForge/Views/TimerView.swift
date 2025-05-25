//
//  TimerView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import SwiftUI

struct TimerView: View {
    @Bindable var timerState: TimerState
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(timerState.currentSession.title)
                    .font(.headline)
                    .foregroundColor(Color.textPrimary)
                    .padding(.vertical, 4)
                   
                if let title = timerState.nextSessionTitle {
                    HStack {
                        Text(Image(systemName: "arrow.forward.circle.dotted"))
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.7))
                            .padding(.vertical, 4)
                        Text("\(title)")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.7))
                            .padding(.vertical, 4)
                    }
                   
                }
              
            }
            .id(timerState.currentSession.title)
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            .animation(.easeInOut(duration: 0.3), value: timerState.currentSession.title)
            
            Text(formattedTime)
                .foregroundStyle(Color.textPrimary)
                .font(.system(size: 42, weight: .bold, design: .monospaced))
                .frame(width: 140, alignment: .center) // фиксированная ширина
                .animation(nil, value: formattedTime)
            Group {
                switch timerState.status {
                case .idle:
                    Spacer()
                    VStack {
                        Button("Start") {
                            withAnimation {
                                timerState.start()
                            }
                        }
                        .buttonStyle(ForgeButtonStyles.Primary())
                        .transition(.opacity)
                    }
                case .running:
                    VStack {
                        Button("Pause") {
                            withAnimation {
                                timerState.pause()
                            }
                        }
                        .buttonStyle(ForgeButtonStyles.Primary())
                        Button("Reset") {
                            withAnimation {
                                timerState.finalize()
                            }
                        }
                        .buttonStyle(ForgeButtonStyles.Secondary())
                    }
                    .transition(.opacity)
                case .paused(let remaining):
                    Spacer()
                    Button("Continue") {
                        withAnimation {
                            timerState.start(from: remaining)
                        }
                    }
                    .buttonStyle(ForgeButtonStyles.Primary())
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: timerState.status)
            Spacer()
        }
    }
    
    private var formattedTime: String {
        TimeFormatter.string(from: timerState.displayTime)
    }
}

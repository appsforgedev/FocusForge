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

            HStack {
                Text(timerState.currentSession.title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 4)
//                if let title = viewModel.nextSession?.title {
//                    Text("-> \(title)")
//                        .font(.subheadline)
//                        .foregroundColor(.gray.opacity(0.5))
//                        .padding(.vertical, 4)
//                }
              
            }
            
            Text(formattedTime)
                .font(.system(size: 42, weight: .bold, design: .monospaced))
                .frame(width: 140, alignment: .center) // фиксированная ширина
                .animation(nil, value: formattedTime)
            
            if !timerState.isRunning {
                Button("Start") {
                    timerState.start()
                }
                .buttonStyle(AppsForgeButtonStyles.Primary())
                
            } else {
                HStack {
                    Button("Pause") {
                        timerState.pause()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Primary())
                    Button("Reset") {
                        timerState.reset()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Secondary())
                    Button("Force") {
                        timerState.forceTimer()
                    }
                }
            }
        }
    }
    
    private var formattedTime: String {
        TimeFormatter.string(from: timerState.displayTime)
    }
}

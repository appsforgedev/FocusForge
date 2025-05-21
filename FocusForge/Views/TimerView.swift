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
                   
                if let title = timerState.nextSession?.title {
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
                .font(.system(size: 42, weight: .bold, design: .monospaced))
                .frame(width: 140, alignment: .center) // фиксированная ширина
                .animation(nil, value: formattedTime)
            
            switch timerState.status {
            case .idle:
                Button("Start") {
                    timerState.start()
                }
                .buttonStyle(AppsForgeButtonStyles.Primary())
            case .running:
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
            case .paused(let remaining):
                Button("Continue") {
                    timerState.start(from: remaining)
                }
                .buttonStyle(AppsForgeButtonStyles.Primary())
            }
        }
    }
    
    private var formattedTime: String {
        TimeFormatter.string(from: timerState.displayTime)
    }
}

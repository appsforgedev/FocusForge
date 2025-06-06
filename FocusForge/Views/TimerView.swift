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
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Text(timerState.currentSession.title)
                    .font(.forgeTitle)
                    .foregroundColor(Color.textPrimary)
                    .padding(.vertical, 4)
                   
                if let title = timerState.nextSessionTitle {
                    HStack {
                        Text(Image(systemName: "arrow.forward.circle.dotted"))
                            .font(.forgeSecond)
                            .foregroundColor(.gray.opacity(0.7))
                        Text("\(title)")
                            .font(.forgeSecond)
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .padding(.vertical, 4)
                }
              
            }
            .id(timerState.currentSession.title)
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            .animation(.easeInOut(duration: 0.3), value: timerState.currentSession.title)
            
            ZStack {
                ForgeProgressBar(
                    progress: progress,
                    color: progressColor(for: timerState.currentSession)
                )
                .opacity(timerState.isRunning ? 1 : 0)
            }
            .frame(height: 6)
            .padding(.vertical, 4)
            
            Text(formattedTime)
                .foregroundStyle(Color.textPrimary)
                .font(.forgeTimer)
                .frame(width: 140, alignment: .center) // фиксированная ширина
                .animation(nil, value: formattedTime)
                .padding(.top, 8)
                .padding(.bottom, 12)
            
            ButtonContainer
            Spacer()
        }
    }
    
    var ButtonContainer: some View {
        HStack {
            switch timerState.status {
            case .idle:
                TimerButton.play {
                    withAnimation {
                        timerState.start()
                    }
                }
            case .running:
                HStack {
                    TimerButton.reset {
                        withAnimation {
                            timerState.finalize()
                        }
                    }
                    TimerButton.pause {
                        withAnimation {
                            timerState.pause()
                        }
                    }
                    TimerButton.skip {
                        print("Skip")
                    }
                }
            case .paused(let remaining):
                HStack {
                    TimerButton.reset {
                        withAnimation {
                            timerState.finalize()
                        }
                    }
                    TimerButton.play {
                        withAnimation {
                            timerState.start(from: remaining)
                        }
                    }
                    TimerButton.skip {
                        print("Skip")
                    }
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.25), value: timerState.status)
    }
}


extension TimerView {
    private var formattedTime: String {
        TimeFormatter.string(from: timerState.displayTime)
    }
    
    private var progress: CGFloat {
        guard timerState.timeRemaining > 0 else { return 0 }
        return 1 - timerState.timeRemaining / timerState.currentDuration
    }
    
    private func progressColor(for type: PomodoroSession) -> Color {
        switch type {
        case .focus:
            return .sessionFocus
        case .shortBreak:
            return .sessionShortBreak
        case .longBreak:
            return .sessionLongBreak
        }
    }
}

#Preview {
    TimerView(timerState: .init(environment: .preview()))
        .frame(width: 300, height: 280)
        .background(Color.backgroundColor)
}

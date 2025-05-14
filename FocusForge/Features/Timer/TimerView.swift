//
//  TimerView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.formattedTime)
                .font(.system(size: 42, weight: .bold, design: .monospaced))
                .frame(width: 140, alignment: .center) // фиксированная ширина
                .animation(nil, value: viewModel.formattedTime)
            
            Text(viewModel.currentSession.title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            FlameView(
                isAnimating: $viewModel.isRunning,
                currentSession: $viewModel.currentSession,
                currentProgress: $viewModel.currentProgress
            )
            .padding()
            
            if !viewModel.isRunning {
                Button("Start") {
                    viewModel.toggleTimer()
                }
                
            } else {
                HStack {
                    Button("Pause") {
                        viewModel.toggleTimer()
                    }
                    Button("Reset") {
                        viewModel.reset()
                    }
                    Button("Force") {
                        viewModel.forceHalfTimer()
                    }
                }
            }
        }
    }
}

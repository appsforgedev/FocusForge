//
//  MenuBarView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 11.05.2025.
//


import SwiftUI

struct MenuBarView: View {
    @ObservedObject var viewModel: PomodoroViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text(viewModel.displayTime)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
            Text(viewModel.currentSession.title)
                .font(.headline)
                .foregroundColor(.secondary)
            VStack(spacing: 10) {
                FlameView(isAnimating: $viewModel.isRunning)
                if !viewModel.isRunning {
                    Button("Start") {
                        viewModel.toggleTimer()
                    }
                    .font(.headline)
                    .padding(5)
                } else {
                    HStack {
                        Button("Pause") {
                            viewModel.toggleTimer()
                        }
                        .font(.headline)
                        .padding(5)
                        Button("Reset") {
                            viewModel.reset()
                        }
                        .font(.headline)
                        .padding(5)
                    }
                }
            }
            .frame(width: 150)
        }
        .padding()
        .animation(.easeInOut, value: viewModel.isRunning)
        
    }
}

#Preview {
    MenuBarView(viewModel: PomodoroViewModel())
}

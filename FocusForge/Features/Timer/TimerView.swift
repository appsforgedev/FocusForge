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

            HStack {
                Text(viewModel.currentSession.title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 4)
                if let title = viewModel.nextSession?.title {
                    Text("-> \(title)")
                        .font(.subheadline)
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.vertical, 4)
                }
              
            }
            
            Text(viewModel.formattedTime)
                .font(.system(size: 42, weight: .bold, design: .monospaced))
                .frame(width: 140, alignment: .center) // фиксированная ширина
                .animation(nil, value: viewModel.formattedTime)
            
            if !viewModel.isRunning {
                Button("Start") {
                    viewModel.toggleTimer()
                }
                .buttonStyle(AppsForgeButtonStyles.Primary())
                
            } else {
                HStack {
                    Button("Pause") {
                        viewModel.toggleTimer()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Primary())
                    Button("Reset") {
                        viewModel.reset()
                    }
                    .buttonStyle(AppsForgeButtonStyles.Secondary())
                    Button("Force") {
                        viewModel.forceTimer()
                    }
                }
            }
        }
    }
}

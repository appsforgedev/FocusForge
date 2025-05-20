//
//  FlameView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 11.05.2025.
//


import SwiftUI
import Combine

struct FlameView: View {
    @Binding var isAnimating: Bool
    @Binding var currentSession: PomodoroSession
    @Binding var currentProgress: Double
    @State private var animate = false

    var body: some View {
        Image(systemName: currentSession.iconForSession(progress: currentProgress))
            .resizable()
            .scaledToFit()
            .frame(width: 75, height: 80)
            .scaleEffect(animate ? 1 : 0.95)
            .foregroundStyle(
                animate
                ? LinearGradient(
                    gradient: Gradient(colors: [.orange, .red, .yellow]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                : LinearGradient(
                    gradient: Gradient(colors: [.orange, .orange]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .rotationEffect(animate ? .degrees(3) : .degrees(0))
            .shadow(color: .orange.opacity(animate ? 0.6 : 0.2), radius: animate ? 12 : 4, x: 0, y: 0)
            .animation(
                isAnimating
                ? Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                : .default,
                value: animate
            )
            .onAppear {
                if isAnimating {
                    animate = true
                }
            }
            .onReceive(Just(isAnimating)) { newValue in
                animate = newValue
            }
    }
}

//
//  ForgeProgressBar.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 26.05.2025.
//


import SwiftUI

struct ForgeProgressBar: View {
    var progress: CGFloat
    var color: Color
    var height: CGFloat = 4
    var padding: CGFloat = 50      

    @State private var animatedProgress: CGFloat = 0
    @State private var pulse = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Фон
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: height)

                // Градиентная заливка
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.6),
                                color
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * animatedProgress, height: height)
                    .scaleEffect(x: pulse ? 1.02 : 1.0, y: 1.0, anchor: .center)
                    .opacity(pulse ? 0.7 : 1.0)
                    .shadow(color: color.opacity(0.4), radius: pulse ? 4 : 2)

                // Вспышка
                if pulse {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 10, height: height)
                        .offset(x: geometry.size.width * animatedProgress - 5)
                        .blur(radius: 1.5)
                        .animation(.easeOut(duration: 0.3), value: progress)
                }
            }
        }
        .frame(height: height)
        .padding(.horizontal, padding)
        .onAppear {
            animatedProgress = progress
            pulse = true
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }
}

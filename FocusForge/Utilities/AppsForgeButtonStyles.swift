//
//  AppsForgeButtonStyles.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 16.05.2025.
//


import SwiftUI

struct AppsForgeButtonStyles {
    
    struct Primary: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(colors: [Color.orange, Color.red], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(12)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }

    struct Secondary: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
        }
    }

    struct Minimal: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .opacity(configuration.isPressed ? 0.5 : 1.0)
        }
    }
}

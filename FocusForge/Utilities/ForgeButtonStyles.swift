//
//  AppsForgeButtonStyles.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 16.05.2025.
//


import SwiftUI

struct ForgeButtonStyles {
    
    struct Primary: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .foregroundColor(Color.buttonPrimaryText)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.buttonPrimaryBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.buttonPrimaryText.opacity(0.6), lineWidth: 1)
                        )
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }

    struct Secondary: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.buttonSecondary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.black.opacity(0.8), lineWidth: 1)
                        )
                )
                .cornerRadius(6)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
        }
    }

    struct Minimal: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.footnote)
                .foregroundColor(Color.textPrimary)
                .frame(minWidth: 75, maxWidth: 85, minHeight: 14)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.buttonSecondary, lineWidth: 1)
                )
                .contentShape(Rectangle())
                .opacity(configuration.isPressed ? 0.5 : 1.0)
        }
    }
}

//
//  AlertView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 24.05.2025.
//

import SwiftUI

public struct AlertView: View {
    public let title: String? = nil
    public let message: String
    public let buttonTitle: String
    public let onConfirm: (() -> Void)?
    public let onCancel: (() -> Void)?
    
    public var body: some View {
        VStack(spacing: 16) {
            Text(title ?? "Attention")
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundStyle(.textPrimary)
            Spacer()
            Text(message)
                .multilineTextAlignment(.center)
                .font(.system(size: 14))
                .foregroundStyle(.textPrimary)
            Spacer()
            Button(buttonTitle) {
                onConfirm?()
            }
            .buttonStyle(ForgeButtonStyles.Primary())
            .keyboardShortcut(.defaultAction)
            if let onCancel {
                Button("Cancel") {
                    onCancel()
                }
                .buttonStyle(ForgeButtonStyles.Minimal())
                .keyboardShortcut(.cancelAction)
            }
            
        }
        .padding()
        .frame(width: 300, height: 250)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundColor)
                   .overlay(
                       RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                   )
        )

    }
}

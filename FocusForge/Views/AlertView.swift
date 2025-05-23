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
            Spacer()
            Text(message)
                .multilineTextAlignment(.center)
                .font(.system(size: 14))
            Spacer()
            Button(buttonTitle) {
                onConfirm?()
            }
            .keyboardShortcut(.defaultAction)
            Button("Cancel") {
                onCancel?()
            }
            .keyboardShortcut(.cancelAction)
        }
        .padding()
        .frame(width: 300, height: 250)
        .background(
            RoundedRectangle(cornerRadius: 12)
                   .fill(Color(NSColor.windowBackgroundColor)) // или другой фон
                   .overlay(
                       RoundedRectangle(cornerRadius: 12)
                           .stroke(Color.gray, lineWidth: 1)
                   )
        )

    }
}

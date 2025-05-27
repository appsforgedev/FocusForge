//
//  ForgeToggleStyles.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 26.05.2025.
//


import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    var fillColor: Color = .green
    var borderColor: Color = .gray
    var checkmarkColor: Color = .white
    var size: CGFloat = 20

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button(action: { configuration.isOn.toggle() }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor, lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(configuration.isOn ? fillColor : .clear)
                        )
                        .frame(width: size, height: size)
                        .contentShape(Rectangle())

                    if configuration.isOn {
                        Image(systemName: "checkmark")
                            .foregroundColor(checkmarkColor)
                            .font(.system(size: size * 0.6, weight: .bold))
                    }
                }
            }
            .buttonStyle(.plain)

            configuration.label
        }
    }
}

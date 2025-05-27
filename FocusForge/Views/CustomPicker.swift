//
//  CustomPicker.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 27.05.2025.
//

import SwiftUI

struct CustomPicker<T: Hashable & Identifiable>: View {
    let title: String
    let options: [T]
    @Binding var selection: T

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.forgeBody)
                .foregroundStyle(.textPrimary)

            HStack(spacing: 8) {
                ForEach(options) { option in
                    Text(optionLabel(for: option))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(selection == option ? Color.accentColor : Color.gray.opacity(0.2))
                        )
                        .foregroundStyle(selection == option ? Color.white : .textPrimary)
                        .font(.forgeSecond)
                        .onTapGesture {
                            selection = option
                        }
                }
            }
        }
    }

    private func optionLabel(for option: T) -> String {
        if let label = option as? CustomPickerLabelRepresentable {
            return label.label
        }
        return String(describing: option)
    }
}

protocol CustomPickerLabelRepresentable {
    var label: String { get }
}

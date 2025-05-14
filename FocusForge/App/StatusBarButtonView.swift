//
//  StatusBarButtonView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 14.05.2025.
//

import Foundation
import AppKit

class StatusBarButtonView: NSView {
    let imageView = NSImageView()
    let textField = NSTextField(labelWithString: "")

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        imageView.symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        imageView.contentTintColor = .systemOrange
        imageView.translatesAutoresizingMaskIntoConstraints = false

        textField.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        textField.textColor = .labelColor
        textField.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(textField)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(icon: NSImage?, title: String, tintColor: NSColor, animated: Bool = true) {
        guard animated else {
            imageView.image = icon
            imageView.contentTintColor = tintColor
            textField.stringValue = title
            return
        }

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            self.animator().alphaValue = 0
        } completionHandler: {
            self.imageView.image = icon
            self.imageView.contentTintColor = tintColor
            self.textField.stringValue = title
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.25
                self.animator().alphaValue = 1
            }
        }
    }
}

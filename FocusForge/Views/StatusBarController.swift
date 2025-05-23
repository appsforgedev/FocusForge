//
//  StatusBarController.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 13.05.2025.
//


import AppKit
import Cocoa
import SwiftUI

class StatusBarController {
    private var statusItem: NSStatusItem
    private var mainWindow: NSWindow?

    init(mainView: any View) {
        let hostingController = NSHostingController(rootView: AnyView(mainView))

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 280, height: 280),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        window.level = .floating
        window.contentView = hostingController.view
        window.isReleasedWhenClosed = false
        window.collectionBehavior = [.transient]
        
        self.mainWindow = window

        statusItem = NSStatusBar.system.statusItem(withLength: 70)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "flame.fill", accessibilityDescription: "FocusForge")?
                .withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 14, weight: .regular))
            button.action = #selector(toggleWindow(_:))
            button.imagePosition = .imageLeading
            button.title = "00:00"
            button.target = self
        }
    }

    @objc private func toggleWindow(_ sender: AnyObject?) {
        guard let window = mainWindow, let button = statusItem.button else { return }

        if window.isVisible {
            window.orderOut(nil)
        } else {
            guard button.window?.screen != nil
            else {
                return
            }
            let buttonFrame = button.window!.convertToScreen(button.frame)
            let x = buttonFrame.origin.x + button.frame.width / 2 - 280 / 2
            let y = buttonFrame.origin.y - 280
            window.setFrameOrigin(NSPoint(x: x, y: y))
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func updateStatus(
        session: PomodoroSession,
        time: String,
        progress: Double,
        isRunning: Bool
    ) {
        let progress = isRunning ? progress : 1.0
        let iconName = session.iconForSession(progress: progress)
        if let baseImage = NSImage(
            systemSymbolName: iconName,
            accessibilityDescription: nil
        ) {
            let configuredImage = baseImage
                .withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 14, weight: .regular))
            Task { @MainActor in
                if let button = statusItem.button {
                    button.font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular)
                    button.image = configuredImage
                    button.title = "\(time)"
                }
            }
        }
    }
}


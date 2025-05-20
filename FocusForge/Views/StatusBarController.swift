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
    private var popover: NSPopover

    init(mainView: some View) {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 280, height: 280)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: mainView)

        statusItem = NSStatusBar.system.statusItem(withLength: 70)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "flame.fill", accessibilityDescription: "FocusForge")?
                .withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 14, weight: .regular))
            button.action = #selector(togglePopover(_:))
            button.imagePosition = .imageLeading
            button.title = "00:00"
            button.target = self
        }
        
    }
    

    @objc private func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
    func updateStatus(session: PomodoroSession, time: String, progress: Double) {
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

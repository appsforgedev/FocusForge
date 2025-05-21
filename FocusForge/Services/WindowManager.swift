//
//  WindowManager.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import SwiftUI

final class WindowManager {
    private var historyWindow: NSWindow?

    func showHistory() {
        
        defer {
            NSApp.activate(ignoringOtherApps: true)
        }
        
        if historyWindow == nil {
            let historyView = HistoryView()

            let hosting = NSHostingController(rootView: historyView)

            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered,
                defer: false
            )
            window.contentView = hosting.view
            window.isReleasedWhenClosed = false
            window.center()
            window.makeKeyAndOrderFront(nil)
            self.historyWindow = window
        } else {
            historyWindow?.makeKeyAndOrderFront(nil)
        
        }
    }
}

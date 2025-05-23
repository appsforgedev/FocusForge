//
//  WindowManager.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import SwiftUI
import SwiftData

final class WindowManager {
    private var historyWindow: NSWindow?

    func showHistory(modelContext: ModelContext) {
        
        if historyWindow == nil {

            let historyView = HistoryView().modelContext(modelContext)
            let hosting = NSHostingController(rootView: historyView)

            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 800, height: 800),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered,
                defer: false
            )
            window.contentView = hosting.view
            window.isReleasedWhenClosed = false
            window.center()
            window.makeKeyAndOrderFront(nil)
            self.historyWindow = window
            NSApp.activate(ignoringOtherApps: true)
        } else {
            historyWindow?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}

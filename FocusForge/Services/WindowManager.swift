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
    private var alertWindow: NSWindow?
    
    internal init(
        dataManager: DataManager
    ) {
        self.historyWindow = makeHistoryWindow(context: dataManager.modelContext)
    }
    
    func toggleHistory() {
        guard let historyWindow else { return }
        if historyWindow.isVisible {
            historyWindow.orderOut(nil)
        } else {
            historyWindow.isReleasedWhenClosed = false
            historyWindow.center()
            historyWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    func showAlert(
        message: String,
        buttonTitle: String = "OK",
        onConfirm: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        guard alertWindow == nil else { return }
        
        let alertView = AlertView(message: message, buttonTitle: buttonTitle) {
            self.alertWindow?.close()
            self.alertWindow = nil
            onConfirm?()
        } onCancel: {
            self.alertWindow?.close()
            self.alertWindow = nil
            onCancel?()
        }

        let hostingController = NSHostingController(rootView: alertView)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 120),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.hasShadow = true
        window.backgroundColor = .clear
        window.level = .floating
        window.center()
        window.contentView = hostingController.view
        window.makeKeyAndOrderFront(nil)
        window.isReleasedWhenClosed = false
        
        self.alertWindow = window
        NSApp.activate(ignoringOtherApps: true)
    }

    
    private func makeHistoryWindow(context: ModelContext) -> NSWindow {
        let historyView = HistoryViewDataContainer().modelContext(context)
        let hosting = NSHostingController(rootView: historyView)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 940, height: 550),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.contentView = hosting.view
        window.backgroundColor = .background

        return window
    }
}

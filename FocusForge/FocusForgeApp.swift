//
//  FocusForgeApp.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 11.05.2025.
//


import SwiftUI

@main
struct FocusForgeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

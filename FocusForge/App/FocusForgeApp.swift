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
    @State private var appState: AppState!
    
    private let environment = AppEnvironment.live()

    init() {
        _appState = State(wrappedValue: AppState(environment: environment))
    }
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

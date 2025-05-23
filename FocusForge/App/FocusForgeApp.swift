//
//  FocusForgeApp.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 11.05.2025.
//


import SwiftUI
import SwiftData

@main
struct FocusForgeApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appState: AppState!
    
    private let environment: AppEnvironment
    private let modelContainer: ModelContainer

    init() {
        let schema = Schema([SessionEntity.self, CycleEntity.self])
        let config = ModelConfiguration("FocusForge", schema: schema)
        self.modelContainer = try! ModelContainer(for: schema, configurations: [config])
        self.environment = AppEnvironment.live(context: modelContainer.mainContext)
        _appState = State(wrappedValue: AppState(environment: environment))
    }
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

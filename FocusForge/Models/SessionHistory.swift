//
//  SessionHistory.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import Foundation

struct SessionHistory: Identifiable {
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var type: PomodoroSession
}

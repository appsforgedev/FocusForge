//
//  CycleEntity.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import Foundation
import SwiftData

@Model
final class CycleEntity {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var endDate: Date?
    var sessions: [SessionEntity] = []
    
    var sortedSessions: [SessionEntity] {
        sessions.sorted { $0.startTime < $1.startTime }
    }
    
    var isFull: Bool {
        sessions.contains { $0.type == "longBreak" }
    }

    init(startDate: Date = .now) {
        self.id = UUID()
        self.startDate = startDate
    }
}

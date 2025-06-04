//
//  CycleEntity.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import Foundation
import SwiftData

@Model
final class CycleEntity: Identifiable {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var endDate: Date?
    var sessions: [SessionEntity] = []
    
    var displayName: String {
        startDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    var isFull: Bool {
        sessions.contains { $0.type == "longBreak" } && !sessions.contains { $0.isInterrupted }
    }

    init(startDate: Date = .now) {
        self.id = UUID()
        self.startDate = startDate
    }
}

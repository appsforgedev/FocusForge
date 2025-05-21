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

    init(startDate: Date = .now) {
        self.id = UUID()
        self.startDate = startDate
    }
}

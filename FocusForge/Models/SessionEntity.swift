//
//  SessionEntity.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import Foundation
import SwiftData

@Model
final class SessionEntity {
    @Attribute(.unique) var id: UUID
    var type: String
    var startTime: Date
    var endTime: Date
    var isInterrupted: Bool
    var cycle: CycleEntity?

    init(type: String, startTime: Date, endTime: Date, isInterrupted: Bool = false, cycle: CycleEntity? = nil) {
        self.id = UUID()
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.isInterrupted = isInterrupted
        self.cycle = cycle
    }
}

extension SessionEntity {
    var durationInMinutes: Int {
        Int(endTime.timeIntervalSince(startTime) / 60)
    }

    var sessionDate: Date {
        Calendar.current.startOfDay(for: startTime)
    }

    var sessionWeek: Date {
        Calendar.current.dateInterval(of: .weekOfYear, for: startTime)?.start ?? sessionDate
    }
}


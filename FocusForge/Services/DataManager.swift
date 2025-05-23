//
//  DataManager.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import Foundation
import SwiftData

final class DataManager {
    
    let modelContext: ModelContext
    
    private(set) var activeCycle: CycleEntity?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // Запуск нового цикла
    func startNewCycle(at date: Date) {
        let newCycle = CycleEntity(startDate: date)
        modelContext.insert(newCycle)
        self.activeCycle = newCycle
    }

    // Завершение текущего цикла (например, после длинного перерыва)
    func finishCurrentCycle() {
        self.activeCycle = nil
    }
    
    func recordSession(
        type: PomodoroSession,
        start: Date,
        end: Date,
        interrupted: Bool = false
    ) {
        let context = modelContext

        // Если активного цикла нет, создаем
        if activeCycle == nil {
            activeCycle = CycleEntity(startDate: start)
            context.insert(activeCycle!)
        }

        let session = SessionEntity(
            type: type.rawValue,
            startTime: start,
            endTime: end,
            isInterrupted: interrupted,
            cycle: activeCycle
        )
        
        activeCycle?.sessions.append(session)
        context.insert(session)
    }
    
    func clearDataBase() {
        do {
            for session in try modelContext.fetch(FetchDescriptor<SessionEntity>()) {
                modelContext.delete(session)
            }
            try modelContext.delete(model: CycleEntity.self)
            try modelContext.save()
        } catch {
            print("Failed to clear all Sessions data.")
        }
    }
}

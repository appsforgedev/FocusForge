//
//  HistoryState.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 27.05.2025.
//

import Foundation

@Observable
final class HistoryState {
    var cycles: [CycleEntity] = []
    var sessions: [SessionEntity] = []

    var selectedSession: SessionEntity?
    var filter: SessionFilter = .all

    // Computed
    var visibleSessions: [SessionEntity] {
        var result = sessions

        // Применение фильтра
        switch filter {
        case .all:
            break
        case .interruptedOnly:
            result = result.filter { $0.isInterrupted }
        case .successfulOnly:
            result = result.filter { !$0.isInterrupted }
        }

        return result
    }
    
    var groupedSessions: [(cycle: CycleEntity?, sessions: [SessionEntity])] {
        Dictionary(grouping: visibleSessions, by: { $0.cycle })
            .sorted { (lhs, rhs) in
                (lhs.key?.startDate ?? .distantPast) > (rhs.key?.startDate ?? .distantPast)
            }
            .map { (key: CycleEntity?, value: [SessionEntity]) in
                return (cycle: key, sessions: value)
            }
    }
    
    var groupedSessionsByDate: [(date: Date, cycles: [(cycle: CycleEntity?, sessions: [SessionEntity])])] {
        let calendar = Calendar.current

        let sessionsByDate = Dictionary(grouping: visibleSessions) { session in
            calendar.startOfDay(for: session.startTime)
        }

        let result: [(Date, [(CycleEntity?, [SessionEntity])])] = sessionsByDate.map { (date, sessions) in
            let groupedByCycle = Dictionary(grouping: sessions, by: { $0.cycle })
                .map { (cycle, sessions) in (cycle, sessions) }
                .sorted { (lhs, rhs) in
                    (lhs.0?.startDate ?? .distantPast) > (rhs.0?.startDate ?? .distantPast)
                }

            return (date, groupedByCycle)
        }
        .sorted { $0.0 > $1.0 }

        return result
    }

    var weekDayAggregates: [(String, Int)] {
        var aggregates: [(String, Int)] = Array(repeating: ("", 0), count: 7)
        
        for session in visibleSessions {
            let index = Calendar.current.component(.weekday, from: session.startTime) - 1
            aggregates[index].1 += 1
        }
        
        return aggregates
    }

    var sessionCountSummary: String {
        "\(sessions.count) sessions — \(sessions.filter { !$0.isInterrupted }.count) full / \(sessions.filter { $0.isInterrupted }.count) interrupted / \(sessions.filter { $0.isSkipped }.count) skipped"
    }

    init(cycles: [CycleEntity], sessions: [SessionEntity]) {
        self.cycles = cycles
        self.sessions = sessions
    }

    func select(session: SessionEntity) {
        selectedSession = session
    }

    func clearSelection() {
        selectedSession = nil
    }
}

enum SessionFilter: String, CaseIterable, Identifiable {
    case all
    case successfulOnly
    case interruptedOnly

    var id: String { rawValue }
   
}

extension SessionFilter: CustomPickerLabelRepresentable {
    var label: String {
        switch self {
        case .all: return "All"
        case .successfulOnly: return "Success"
        case .interruptedOnly: return "Interrupted"
        }
    }
}

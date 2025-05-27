//
//  HistoryState.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 27.05.2025.
//

import Foundation

@Observable
final class HistoryState {
    // Сырые данные
    var cycles: [CycleEntity] = []
    var sessions: [SessionEntity] = []

    // UI-состояние
    var selectedSession: SessionEntity?
    var filter: SessionFilter = .all
    var sortOrder: SortOrder = .byDateDescending

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

        // Применение сортировки
        switch sortOrder {
        case .byDateDescending:
            result = result.sorted(by: { $0.startTime > $1.startTime })
        case .byDateAscending:
            result = result.sorted(by: { $0.startTime < $1.startTime })
        }

        return result
    }

    var sessionCountSummary: String {
        "\(sessions.count) sessions — \(sessions.filter { !$0.isInterrupted }.count) full / \(sessions.filter { $0.isInterrupted }.count) interrupted"
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

enum SortOrder: String, CaseIterable, Identifiable {
    case byDateDescending
    case byDateAscending

    var id: String { rawValue }
}

extension SortOrder: CustomPickerLabelRepresentable {
    var label: String {
        switch self {
        case .byDateDescending: return "Newest"
        case .byDateAscending: return "Oldest"
        }
    }
}


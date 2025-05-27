//
//  HistoryViewDataContainer.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 27.05.2025.
//

import SwiftData
import SwiftUI

struct HistoryViewDataContainer: View {
    @Query(sort: \CycleEntity.startDate, order: .reverse) var cycles: [CycleEntity]
    @Query(sort: \SessionEntity.startTime, order: .reverse) var sessions: [SessionEntity]
    
    var body: some View {
        HistoryView(state: HistoryState(cycles: cycles, sessions: sessions))
    }
}

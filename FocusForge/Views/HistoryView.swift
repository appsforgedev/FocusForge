//
//  HistoryView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query var cycles: [CycleEntity]
    @Query(sort: \SessionEntity.startTime, order: .reverse) var records: [SessionEntity]

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        VStack {
            List {
                ForEach(cycles) { cycle in
                    HStack {
                        Text(cycle.startDate.formatted(date: .numeric, time: .shortened))
                        Spacer()
                        Text("Количество сессий: \(cycle.sessions.count)")
                    }
                }
            }
            List {
                ForEach(records) { record in
                    HStack {
                        Text(record.type.capitalized)
                        Spacer()
                        Text(record.startTime.formatted(date: .abbreviated, time: .shortened))
                        Text(record.isInterrupted ? "Interrupted" : "Full")
                    }
                    .padding()
                }
            }
            
        }
    }
}

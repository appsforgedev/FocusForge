//
//  HistoryView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \CycleEntity.startDate, order: .reverse) var cycles: [CycleEntity]
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
                        Text(cycle.startDate.formatted(date: .numeric, time: .complete))
                        Text("Is full: \(cycle.isFull ? "Yes" : "No")")
                        Text("Sessions count: \(cycle.sessions.count)")
                        ForEach(cycle.sortedSessions) { session in
                            HStack {
//                                Text("\(session.id)").scaledToFit()
                                Text(session.symbol)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .frame(width: 16, height: 16)
//                                    .background(session.isInterrupted ? .red : .green)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(session.isInterrupted ? .red : .green, lineWidth: 1)
                                    )
//                                Spacer()
////                                Text(session.startTime.formatted(date: .abbreviated, time: .complete))
//                                Text(session.isInterrupted ? "Interrupted" : "Full")
                            }
                        }
                    }
                }
            }
            List {
                ForEach(records) { record in
                    HStack {
                        Text("\(record.id)").scaledToFit()
                        Text(record.type.capitalized)
                        Spacer()
                        Text(record.startTime.formatted(date: .abbreviated, time: .complete))
                        Text(record.isInterrupted ? "Interrupted" : "Full")
                    }
                    .padding()
                }
            }
            
        }
    }
}

extension SessionEntity {
    var symbol: String {
        self.type.first?.uppercased() ?? "?"
    }
}

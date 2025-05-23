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
            VStack {
                List {
                    ForEach(cycles) { cycle in
                        HStack {
                            Text(cycle.startDate.formatted(date: .numeric, time: .complete))
                            Text("Is full: \(cycle.isFull ? "Yes" : "No")")
                            Text("Sessions count: \(cycle.sessions.count)")
                            ForEach(cycle.sortedSessions) { session in
                                HStack {
                                    //                                Text(session.symbol)
                                    Image(systemName: "\(session.symbol).square")
                                        .font(.system(size: 18))
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.black, session.isInterrupted ? .red : .green)
                                }
                            }
                        }
                    }
                }
                LegendView()
                    .background(.blue)
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

struct LegendView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Legend")
                .font(.headline)
            HStack {
                Spacer()
                ForEach(PomodoroSession.allCases) { session in
                    HStack {
                        Image(systemName: "\(session.sybmol).square")
                            .font(.footnote)
                        Text("- \(session.title)")
                            .font(.footnote)
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                HStack {
                    Image(systemName: "square")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                    Text("- Success session")
                        .font(.subheadline)
                }
                HStack {
                    Image(systemName: "square")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                    Text("- Interrupt session")
                        .font(.subheadline)
                }
                Spacer()
            }
        }
    }
}

extension SessionEntity {
    var symbol: String {
        self.type.first?.lowercased() ?? "?"
    }
}

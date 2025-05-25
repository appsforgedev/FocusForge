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
                ZStack {
                    Color.background.ignoresSafeArea()
                    List {
                        ForEach(cycles) { cycle in
                            HStack {
                                Text(cycle.startDate.formatted(date: .numeric, time: .complete))
                                    .foregroundStyle(.textPrimary)
                                Text("Is full: \(cycle.isFull ? "Yes" : "No")")
                                    .foregroundStyle(.textPrimary)
                                Text("Sessions count: \(cycle.sessions.count)")
                                    .foregroundStyle(.textPrimary)
                                ForEach(cycle.sortedSessions) { session in
                                    HStack {
                                        Image(systemName: "\(session.symbol).square")
                                            .font(.system(size: 18))
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(Color.textPrimary, session.isInterrupted ? Color.error : .success)
                                    }
                                    
                                }
                            }
                        }
                    }
                    .background(Color.clear)
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .scrollContentBackground(.hidden)
                }
                LegendView()
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
                .foregroundStyle(.textPrimary)
                .padding(4)
            HStack {
                Spacer()
                ForEach(PomodoroSession.allCases) { session in
                    HStack {
                        Image(systemName: "\(session.sybmol).square")
                            .font(.footnote)
                            .foregroundStyle(.textPrimary)
                        Text("- \(session.title)")
                            .font(.footnote)
                            .foregroundStyle(.textPrimary)
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                HStack {
                    Image(systemName: "square")
                        .font(.subheadline)
                        .foregroundStyle(.success)
                    Text("- Success session")
                        .font(.subheadline)
                        .foregroundStyle(.textPrimary)
                }
                HStack {
                    Image(systemName: "square")
                        .font(.subheadline)
                        .foregroundStyle(.error)
                    Text("- Interrupt session")
                        .font(.subheadline)
                        .foregroundStyle(.textPrimary)
                }
                Spacer()
            }
            .padding(.bottom, 8)
        }
        .background(Color.backgroundColor)
    }
}

extension SessionEntity {
    var symbol: String {
        self.type.first?.lowercased() ?? "?"
    }
}

//
//  HistoryChartView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 04.06.2025.
//


import SwiftUI
import Charts

enum GroupingMode {
    case byDay
    case byWeek
}

struct WeekdayChartView: View {
    var state: HistoryState

    var body: some View {
        VStack(alignment: .center) {
            Text("Session count by days")
                .font(.forgeBody)
                .foregroundStyle(.textPrimary)
            Chart {
                ForEach(sortedAggregateByWeekday(state.sessions)) { entry in
                    BarMark(
                        x: .value("Day", weekdaySymbol(for: entry.weekday)),
                        y: .value("Minutes", entry.totalMinutes)
                    )
                    .foregroundStyle(entry.hasInterrupted ? .red : .green)
                    .annotation(position: .top) {
                        VStack(spacing: 2) {
                            Text("\(entry.count)")
                            Text("\(entry.totalMinutes)")
                        }
                        .font(.forgeBody)
                        .foregroundStyle(.textPrimary)
                    }
                }
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, position: .bottom) { value in
                    AxisValueLabel()
                        .font(.forgeBody)
                        .foregroundStyle(.textPrimary)
                    AxisTick()
                }
            }
            .chartYAxis(.hidden)
            .frame(height: 240)
        }
        .padding()
    }
    
    
    fileprivate func sortedAggregateByWeekday(_ sessions: [SessionEntity]) -> [WeekdayAggregate] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(
            grouping: sessions,
            by: { calendar.component(.weekday, from: $0.startTime) }
        )
        
        let weeakDays = (1...7).map { weekday in
            let sessionsForDay = grouped[weekday] ?? []
            return WeekdayAggregate(
                weekday: weekday,
                totalMinutes: sessionsForDay.reduce(0) { $0 + $1.durationInMinutes },
                count: sessionsForDay.count,
                hasInterrupted: sessionsForDay.contains(where: \.isInterrupted)
            )
        }
        
        return sortWeekdayEntriesByLocale(weeakDays)
    }
    
    fileprivate func sortWeekdayEntriesByLocale(_ entries: [WeekdayAggregate]) -> [WeekdayAggregate] {
        let calendar = Calendar.current
        let firstWeekday = calendar.firstWeekday

        let orderedWeekdays = (0..<7).map { (firstWeekday + $0 - 1) % 7 + 1 }

        return entries.sorted {
            orderedWeekdays.firstIndex(of: $0.weekday)! < orderedWeekdays.firstIndex(of: $1.weekday)!
        }
    }
    
    func weekdaySymbol(for weekday: Int) -> String {
        let calendar = Calendar.current
        let symbols = calendar.shortWeekdaySymbols
        return symbols[weekday - 1]
    }
}

private struct WeekdayAggregate: Identifiable {
    let id = UUID()
    let weekday: Int
    let totalMinutes: Int
    let count: Int
    let hasInterrupted: Bool
}


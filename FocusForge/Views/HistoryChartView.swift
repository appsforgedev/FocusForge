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
                    AxisGridLine()
                        .foregroundStyle(.textPrimary)
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
        
        let weekDays = (1...7).map { weekday in
            let sessionsForDay = grouped[weekday] ?? []
            return WeekdayAggregate(
                weekday: weekday,
                totalMinutes: sessionsForDay.reduce(0) { $0 + $1.durationInMinutes },
                count: sessionsForDay.count,
                hasInterrupted: sessionsForDay.contains(where: \.isInterrupted)
            )
        }
        
        return WeekdayAggregate.sortByLocale(weekDays)
    }
    
    func weekdaySymbol(for weekday: Int) -> String {
        let calendar = Calendar.current
        let symbols = calendar.shortWeekdaySymbols
        return symbols[weekday - 1]
    }
}

private struct WeekdayAggregate: Identifiable {
    var id: Int { weekday }
    let weekday: Int
    let totalMinutes: Int
    let count: Int
    let hasInterrupted: Bool
    
    var label: String {
        Calendar.current.shortWeekdaySymbols[weekday - 1]
    }
    
    static func sortByLocale(_ entries: [WeekdayAggregate]) -> [WeekdayAggregate] {
        let calendar = Calendar.current
        let firstWeekday = calendar.firstWeekday
        let orderedWeekdays = (0..<7).map { (firstWeekday + $0 - 1) % 7 + 1 }
        
        return entries.sorted {
            guard let firstIndex = orderedWeekdays.firstIndex(of: $0.weekday),
                  let secondIndex = orderedWeekdays.firstIndex(of: $1.weekday)
            else { return false }
            return firstIndex < secondIndex
        }
    }
}

//MARK: Hexagramma

struct Polygon: Shape {
    let sides: Int

    func path(in rect: CGRect) -> Path {
        guard sides >= 3 else { return Path() }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var path = Path()

        for i in 0..<sides {
            let angle = 2 * .pi / CGFloat(sides) * CGFloat(i) - .pi / 2
            let pt = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            if i == 0 {
                path.move(to: pt)
            } else {
                path.addLine(to: pt)
            }
        }

        path.closeSubpath()
        return path
    }
}

struct HexagonCell: View {
    let label: String
    let count: Int
    let isInterrupted: Bool

    var body: some View {
        ZStack {
            Polygon(sides: 6)
                .fill(isInterrupted ? .red.opacity(0.7) : .green.opacity(0.7))
                .frame(width: 60, height: 60)
                .shadow(radius: 3)

            VStack(spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .bold()
                    .foregroundStyle(.white)
                Text("\(count)")
                    .font(.caption)
                    .foregroundStyle(.white)
            }
        }
    }
}

struct HexagramChartView: View {
    var sessions: [SessionEntity]

    private var aggregated: [WeekdayAggregate] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: sessions) {
            calendar.component(.weekday, from: $0.startTime)
        }

        let allWeekdays = (1...7).map { weekday in
            let daySessions = grouped[weekday] ?? []
            return WeekdayAggregate(
                weekday: weekday,
                totalMinutes: daySessions.reduce(0) { $0 + $1.durationInMinutes },
                count: daySessions.count,
                hasInterrupted: daySessions.contains(where: \.isInterrupted)
            )
        }

        // сортируем с первого дня недели по настройкам пользователя
        let orderedWeekdays = (0..<7).map { (calendar.firstWeekday + $0 - 1) % 7 + 1 }
        return allWeekdays.sorted {
            orderedWeekdays.firstIndex(of: $0.weekday)! < orderedWeekdays.firstIndex(of: $1.weekday)!
        }
    }

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 3

            ZStack {
                ForEach(Array(aggregated.enumerated()), id: \.element.id) { index, item in
                    let angle = Double(index) / Double(aggregated.count) * 2 * .pi
                    let x = center.x + radius * CGFloat(cos(angle))
                    let y = center.y + radius * CGFloat(sin(angle))

                    HexagonCell(
                        label: item.label,
                        count: item.count,
                        isInterrupted: item.hasInterrupted
                    )
                    .position(x: x, y: y)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 300)
    }
}


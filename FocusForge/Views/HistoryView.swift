//
//  HistoryView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import SwiftUI

struct HistoryView: View {
    private var sessions = [
        SessionHistory(id: UUID(), startDate: Date().addingTimeInterval(-3600), type: .focus),
        SessionHistory(id: UUID(), startDate: Date().addingTimeInterval(-7200), type: .longBreak)
    ]
    
    private var dateFormatter: DateFormatter {
        var formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        List(sessions) { session in
            VStack(alignment: .leading) {
                Text("Тип: \(session.type)")
                Text("Начало: \(session.startDate, formatter: dateFormatter)")
                session.endDate.map { date in
                    Text("Конец: \(date, formatter: dateFormatter)")
                }
               
            }
        }
        .padding()
    }
}

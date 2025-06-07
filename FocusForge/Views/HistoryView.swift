//
//  HistoryView.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 21.05.2025.
//

import SwiftUI
import SwiftData


struct HistoryView: View {
    @Bindable var state: HistoryState
    
    var body: some View {
        HStack(spacing: 0) {
            DashboardView(
                state: state,
                selectedSession: state.selectedSession
            )
            .frame(minWidth: 300, maxWidth: 300, maxHeight: .infinity)
            .background(Color.backgroundColor)
            
            Divider()
                .background(.accentSecondary)
            
            SessionsListView(state: state)
                .frame(minWidth: 400)
                .background(Color.backgroundColor)
            
            Divider()
                .background(.accentSecondary)
            Group {
                if let session = state.selectedSession {
                    SessionDetailView(session: session) {
                        withAnimation {
                            state.clearSelection()
                        }
                    }
                    .frame(minWidth: 300, maxHeight: .infinity)
                    .background(Color.backgroundColor)
                    .transition(.blurReplace.combined(with: .opacity))
                    
                }
            }
            .animation(.default.speed(0.5), value: state.selectedSession)
        }
    }
}

struct SessionsListView: View {
    @Bindable var state: HistoryState
    
    var body: some View {
        VStack {
            Text("Sessions")
                .font(.forgeTitle)
                .foregroundStyle(.textPrimary)
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    CustomPicker(title: "Filter", options: SessionFilter.allCases, selection: $state.filter)
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
            
            CycleGroupsListView(state: state)
        }
        .padding()
    }
}

struct CycleGroupsListView: View {
    @Bindable var state: HistoryState
    
    var body: some View {
        List {
            ForEach(state.groupedSessionsByDate, id: \.date) { dateGroup in
                SectionHeaderView(
                    title: dateGroup.date.formatted(date: .abbreviated, time: .omitted)
                )
                Divider()
                    .foregroundStyle(.accentSecondary)
                ForEach(Array(dateGroup.cycles.enumerated()), id: \.1.cycle?.id) { index, cycleGroup in
                    if dateGroup.cycles.count > 1 {
                        Text("Cycle #\(index + 1)")
                            .font(.forgeBody)
                            .foregroundStyle(.textPrimary)
                            .padding(.top, 4)
                            .padding(.leading, 8)
                    }
                    
                    ForEach(cycleGroup.sessions, id: \.id) { session in
                        SessionRow(
                            session: session,
                            isSelected: session.id == state.selectedSession?.id
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                state.select(session: session)
                            }
                        }
                    }
                }
                
            }
        }
        .scrollIndicators(.never)
        .scrollContentBackground(.hidden)
    }
}

struct SessionRow: View {
    let session: SessionEntity
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(session.type.capitalized)
                .font(.forgeBody)
                .foregroundStyle(session.isInterrupted ? .error : .success)
            Spacer()
            Text(session.startTime.formatted(date: .abbreviated, time: .shortened))
                .font(.forgeBody)
                .foregroundStyle(.textPrimary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal)
        .background(isSelected ? Color.gray.opacity(0.1) : Color.clear)
        .frame(maxHeight: .infinity)
    }
}

struct SectionHeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.forgeBody)
                .foregroundStyle(.accentSecondary)
            Spacer()
        }
        .padding(.top, 4)
    }
}

struct SessionDetailView: View {
    
    var session: SessionEntity
    var onClose: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Details")
                .font(.forgeTitle)
                .foregroundStyle(.textPrimary)
            Spacer()
            Spacer()
            VStack(alignment: .leading) {
                Text("Details:")
                Text("Started: \(session.startTime.formatted(date: .long, time: .complete))")
                Text("Ended: \(session.endTime.formatted(date: .long, time: .complete))")
                Text("Duration: \(session.durationInSeconds.formatedToTime)")
                Text("Interrupted: \(session.isInterrupted ? "Yes" : "No")")
                Text("Is Skipped: \(session.isSkipped ? "Yes" : "No")")
            }
            .foregroundStyle(.textPrimary)
            .padding()
            Spacer()
            Button("Close") {
                onClose?()
            }
            .buttonStyle(ForgeButtonStyles.Minimal())
            .padding()
        }
        .padding()
    }
}

struct DashboardView: View {
    var state: HistoryState
    var selectedSession: SessionEntity?
    var body: some View {
        VStack {
            Text("Dashboard")
                .font(.forgeTitle)
                .foregroundStyle(.textPrimary)
            Spacer()
           
            RadarChartView(sessions: state.sessions)
//            WeekdayChartView(state: state)
//            HexagramChartView(sessions: state.sessions)
            Spacer()
            
            Text(state.sessionCountSummary)
                .font(.forgeSecond)
                .foregroundStyle(.textPrimary)
                .padding(.top, 4)
        }
        .padding()
    }
}

extension SessionEntity {
    var symbol: String {
        self.type.first?.lowercased() ?? "?"
    }
}

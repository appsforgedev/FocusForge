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
            DashboardView(selectedSession: state.selectedSession)
                .frame(minWidth: 300, maxWidth: 300, maxHeight: .infinity)
                .background(Color.backgroundColor)
            
            Divider()
                .background(.accentSecondary)
            
            SessionsListView(state: state)
                .frame(minWidth: 400)
                .background(Color.backgroundColor)
            
            Divider()
                .background(.accentSecondary)
            
            if let session = state.selectedSession {
                SessionDetailView(session: session) {
                    withAnimation {
                        state.clearSelection()
                    }
                }
                .frame(minWidth: 300, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .transition(.blurReplace.combined(with: .opacity))
                .animation(.default.speed(0.5), value: state.selectedSession)
            }
        }
    }
}

struct SessionsListView: View {
    @Bindable var state: HistoryState
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    CustomPicker(title: "Filter", options: SessionFilter.allCases, selection: $state.filter)
                    CustomPicker(title: "Sort", options: SortOrder.allCases, selection: $state.sortOrder)
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
            
            List {
                ForEach(state.visibleSessions, id: \.id) { session in
                    HStack {
                        Text(session.type.capitalized)
                            .font(.forgeBody)
                            .foregroundStyle(session.isInterrupted ? .error : .success)
                        Spacer()
                        Text(session.startTime.formatted(date: .abbreviated, time: .shortened))
                            .font(.forgeBody)
                            .foregroundStyle(.textPrimary)
                    }
                    .background(state.selectedSession?.id == session.id ? Color.gray.opacity(0.1) : Color.clear)
                    .frame(maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            state.select(session: session)
                        }
                    }
                }
            }
            .background(Color.clear)
            .listStyle(.plain)
            .listRowInsets(nil)
            .scrollIndicators(.never)
            .scrollContentBackground(.hidden)
            
            Text(state.sessionCountSummary)
                .font(.forgeSecond)
                .foregroundStyle(.textPrimary)
                .padding(.top, 4)
        }
        .padding(8)
    }
}

struct SessionDetailView: View {
    
    var session: SessionEntity
    var onClose: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack(alignment: .leading) {
                Text("Details:")
                Text("Started: \(session.startTime.formatted(date: .long, time: .complete))")
                Text("Interrupted: \(session.isInterrupted ? "Yes" : "No")")
                // Дополнительные детали
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
        
    }
}

struct DashboardView: View {
    var selectedSession: SessionEntity?
    var body: some View {
        VStack {
            Text("Dashboard")
                .foregroundStyle(.textPrimary)
            Text(selectedSession?.symbol ?? "?")
                .foregroundStyle(.textPrimary)
        }
    }
}

struct EmptyDetailView: View {
    
    var body: some View {
        Text("Choose a session in the list")
            .foregroundStyle(.textPrimary)
    }
}

extension SessionEntity {
    var symbol: String {
        self.type.first?.lowercased() ?? "?"
    }
}

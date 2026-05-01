//
//  LogbookListView.swift
//  Angel Flight v2
//
//  Created by OpenAI on 2026-04-28.
//

import SwiftUI

struct LogbookListView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let entrySummaries: [LogbookSummary] = [
        LogbookSummary(title: "All", value: "731.9", filter: .all),
        LogbookSummary(title: "Last 7 Days", value: "0.0", filter: .lastDays(7)),
        LogbookSummary(title: "Last 30 Days", value: "0.0", filter: .lastDays(30)),
        LogbookSummary(title: "Last 90 Days", value: "4.7", filter: .lastDays(90)),
        LogbookSummary(title: "Last 6 Months", value: "39.8", filter: .lastMonths(6)),
        LogbookSummary(title: "Last 12 Months", value: "69.6", filter: .lastMonths(12))
    ]

    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Rectangle()
                    .fill(Gradient(colors: gradientColors))
                    .ignoresSafeArea()
            } else {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            }

            List {
                Section("Entries") {
                    ForEach(entrySummaries) { summary in
                        NavigationLink(destination: LogbookEntriesView(summary: summary)) {
                            LogbookSummaryRow(summary: summary)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
                        .listRowBackground(rowBackground)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Logbook")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var rowBackground: Color {
        colorScheme == .dark ? Color(red: 0.10, green: 0.15, blue: 0.22) : Color(.secondarySystemGroupedBackground)
    }
}

private struct LogbookSummaryRow: View {
    let summary: LogbookSummary

    var body: some View {
        HStack(spacing: 12) {
            Text(summary.title)
                .font(.body.weight(.semibold))

            Spacer()

            Text(summary.value)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 10)
    }
}

private struct LogbookSummary: Identifiable {
    let id: String
    let title: String
    let value: String
    let filter: LogbookFilter

    init(title: String, value: String, filter: LogbookFilter) {
        self.id = title
        self.title = title
        self.value = value
        self.filter = filter
    }
}

private enum LogbookFilter: Hashable {
    case all
    case lastDays(Int)
    case lastMonths(Int)
}

private struct LogbookEntriesView: View {
    let summary: LogbookSummary

    var body: some View {
        List {
            Section {
                Text("Filtered entries for \(summary.title) will appear here once flown missions are loaded from JSON.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(summary.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LogbookListView()
    }
}

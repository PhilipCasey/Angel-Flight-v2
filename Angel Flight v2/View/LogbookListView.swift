//
//  LogbookListView.swift
//  Angel Flight v2
//
//  Created by OpenAI on 2026-04-28.
//

import SwiftUI
import Foundation

struct LogbookListView: View {
    @StateObject private var missionData = Fetcher()

    var body: some View {
        LogbookListContent(entries: missionData.logbookEntries) {
            if missionData.logbookEntries.isEmpty {
                missionData.fetchMissionLog()
            }
        }
    }
}

private struct LogbookListContent: View {
    @Environment(\.colorScheme) private var colorScheme

    let entries: [LogbookEntry]
    let fetchEntriesIfNeeded: () -> Void

    private var entrySummaries: [LogbookSummary] {
        [
            LogbookSummary(title: "All", value: totalHoursText(for: .all), filter: .all),
            LogbookSummary(title: "Last 7 Days", value: totalHoursText(for: .lastDays(7)), filter: .lastDays(7)),
            LogbookSummary(title: "Last 30 Days", value: totalHoursText(for: .lastDays(30)), filter: .lastDays(30)),
            LogbookSummary(title: "Last 90 Days", value: totalHoursText(for: .lastDays(90)), filter: .lastDays(90)),
            LogbookSummary(title: "Last 6 Months", value: totalHoursText(for: .lastMonths(6)), filter: .lastMonths(6)),
            LogbookSummary(title: "Last 12 Months", value: totalHoursText(for: .lastMonths(12)), filter: .lastMonths(12))
        ]
    }

    var body: some View {
        ZStack {
            
            ZStack{
                List {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 75)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 36)
                        .padding(.bottom, 7)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .stretchy()
                    
                    Text("Completed Mission Logbook")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
    
                    Section("Entries") {
                        ForEach(entrySummaries) { summary in
                            NavigationLink(
                                destination: LogbookEntriesView(
                                    title: summary.title,
                                    filter: summary.filter,
                                    entries: entries
                                )
                            ) {
                                LogbookSummaryRow(summary: summary)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
                            .listRowBackground(Color.viewBackground)
                        }
                    }
                    .padding(6)
                }
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
                .background(Gradient(colors: gradientColors))
                
            }
            //.navigationTitle("Logbook")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: fetchEntriesIfNeeded)
        }
    }

    private var rowBackground: Color {
        colorScheme == .dark ? Color(red: 0.10, green: 0.15, blue: 0.22) : Color(.secondarySystemGroupedBackground)
    }

    private func totalHoursText(for filter: LogbookFilter) -> String {
        let total = logbookEntries(from: entries, matching: filter)
            .compactMap { entry in
                Double(entry.totalHoursFlown ?? "")
            }
            .reduce(0, +)

        return String(format: "%.1f", total)
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
    @Environment(\.colorScheme) private var colorScheme

    let title: String
    let filter: LogbookFilter
    let entries: [LogbookEntry]

    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Rectangle()
                    .fill(Gradient(colors: gradientColors))
                    .ignoresSafeArea()
            } else {
                Color.white
                    .ignoresSafeArea()
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    if filteredEntries.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("No flown missions found for this time range.")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(18)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(accentHighlight)
                                .opacity(0.25)
                        }
                    } else {
                        entrySummaryCard

                        ForEach(groupedEntries) { section in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(section.title)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.secondary)

                                ForEach(section.entries) { entry in
                                    NavigationLink(destination: LogbookDetailView(entry: entry)) {
                                        LogbookEntryRow(entry: entry)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
            }
            .padding(14)
            .padding(.horizontal, 5)
            
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var entrySummaryCard: some View {
        HStack {
            
            if filteredEntries.count == 1 {
                Text("\(filteredEntries.count) Entry")
            } else {
                Text("\(filteredEntries.count) Entries")
            }
            
            Spacer()
            Text("\(totalHours) Total Time")
        }
        .font(.headline)
        .foregroundStyle(.secondary)
        .padding(18)
    }

    private var filteredEntries: [LogbookEntry] {
        logbookEntries(from: entries, matching: filter)
    }

    private var groupedEntries: [LogbookSection] {
        Dictionary(grouping: filteredEntries) { entry in
            monthSectionTitle(for: entry)
        }
        .map { LogbookSection(title: $0.key, entries: $0.value) }
        .sorted { lhs, rhs in
            guard
                let lhsDate = lhs.entries.compactMap(logbookDate(for:)).max(),
                let rhsDate = rhs.entries.compactMap(logbookDate(for:)).max()
            else {
                return lhs.title > rhs.title
            }

            return lhsDate > rhsDate
        }
    }

    private var totalHours: String {
        let total = filteredEntries
            .compactMap { Double($0.totalHoursFlown ?? "") }
            .reduce(0, +)

        return String(format: "%.1f", total)
    }
}


// Future Cardview
private struct LogbookEntryRow: View {
    let entry: LogbookEntry

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {

                Text(entry.patientName ?? entry.id)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("\(entry.departureAirport ?? "—") - \(entry.destinationAirport ?? "—")")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(entry.id)
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(shortLogbookDate(for: entry))
                    .font(.subheadline)

                Text("\(entry.totalHoursFlown ?? "0.0") Total")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
                .padding(.top, 4)
        }
        .padding(18)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(accentHighlight)
                .opacity(0.25)
        }
    }
}

private struct LogbookSection: Identifiable {
    let id: String
    let title: String
    let entries: [LogbookEntry]

    init(title: String, entries: [LogbookEntry]) {
        self.id = title
        self.title = title
        self.entries = entries.sorted {
            (logbookDate(for: $0) ?? .distantPast) > (logbookDate(for: $1) ?? .distantPast)
        }
    }
}

let logbookDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d, yyyy"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()

let logbookMonthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()

let shortLogbookDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()

#Preview {
    NavigationStack {
        LogbookListContent(entries: previewLogbookEntries) { }
    }
}

private let previewLogbookEntries = [
    LogbookEntry(
        id: "25-0625-01",
        patientName: "Lorilee Smith",
        missionDate: "April 13, 2026",
        missionDayOfWeek: "Tuesday",
        completionDate: "April 13, 2026",
        completionDayOfWeek: "Tuesday",
        departureCity: "Lawrenceville, GA",
        departureAirport: "LZU",
        destinationCity: "Walterboro, SC",
        destinationAirport: "RBW",
        totalHoursFlown: "4.5",
        totalMilesFlown: "416.0",
        hourlyOperatingCosts: "118.00",
        additionalExpenses: "0.00",
        expenseDescription: "n/a",
        additionalComments: "n/a"
    )
]

private func logbookEntries(from entries: [LogbookEntry], matching filter: LogbookFilter) -> [LogbookEntry] {
    let entriesWithDates = entries.compactMap { entry -> (entry: LogbookEntry, date: Date)? in
        guard let date = logbookDate(for: entry) else {
            return nil
        }

        return (entry, date)
    }

    let filtered = entriesWithDates.filter { item in
        switch filter {
        case .all:
            return true
        case .lastDays(let days):
            guard let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) else {
                return false
            }
            return item.date >= startDate
        case .lastMonths(let months):
            guard let startDate = Calendar.current.date(byAdding: .month, value: -months, to: Date()) else {
                return false
            }
            return item.date >= startDate
        }
    }

    return filtered
        .sorted { $0.date > $1.date }
        .map(\.entry)
}

func logbookDate(for entry: LogbookEntry) -> Date? {
    if let completionDate = entry.completionDate, let date = logbookDateFormatter.date(from: completionDate) {
        return date
    }

    if let missionDate = entry.missionDate, let date = logbookDateFormatter.date(from: missionDate) {
        return date
    }

    return nil
}

private func monthSectionTitle(for entry: LogbookEntry) -> String {
    guard let date = logbookDate(for: entry) else {
        return "Unknown Date"
    }

    return logbookMonthFormatter.string(from: date).uppercased()
}

func shortLogbookDate(for entry: LogbookEntry) -> String {
    guard let date = logbookDate(for: entry) else {
        return "Unknown Date"
    }

    return shortLogbookDateFormatter.string(from: date)
}

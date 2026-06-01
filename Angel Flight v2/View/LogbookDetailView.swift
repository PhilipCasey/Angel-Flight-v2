//
//  LogbookDetailView.swift
//  Angel Flight v2
//
//  Created by OpenAI on 2026-04-28.
//

import SwiftUI

struct LogbookDetailView: View {
    @Environment(\.colorScheme) private var colorScheme

    let entry: LogbookEntry

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
                VStack(spacing: 14) {
                    VStack(spacing: 4) {
                        Text(shortLogbookDate(for: entry))
                            .font(.title3)
                            .foregroundStyle(.secondary)

                        Text("\(entry.departureAirport ?? "—") - \(entry.destinationAirport ?? "—")")
                            .font(.title2.weight(.semibold))

                        Text(entry.patientName ?? entry.id)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 4)

                    detailSection("Mission") {
                        detailRow("Mission ID", entry.id)
                        detailRow("Patient", entry.patientName ?? "N/A")
                        detailRow("Mission Date", entry.missionDate ?? "N/A")
                        detailRow("Completion Date", entry.completionDate ?? "N/A")
                    }

                    detailSection("Route") {
                        detailRow("Departure", "\(entry.departureAirport ?? "—") • \(entry.departureCity ?? "N/A")")
                        detailRow("Destination", "\(entry.destinationAirport ?? "—") • \(entry.destinationCity ?? "N/A")")
                    }

                    detailSection("Flight") {
                        detailRow("Total Hours", entry.totalHoursFlown ?? "0.0")
                        detailRow("Total Miles", entry.totalMilesFlown ?? "0.0")
                        detailRow("Hourly Operating Costs", entry.hourlyOperatingCosts ?? "0.00")
                        detailRow("Additional Expenses", entry.additionalExpenses ?? "0.00")
                    }

                    detailSection("Notes") {
                        detailRow("Expense Description", entry.expenseDescription ?? "N/A")
                        detailRow("Additional Comments", entry.additionalComments ?? "N/A")
                    }
                }
                .padding(14)
                .padding(.horizontal, 5)
            }
        }
        .navigationTitle("\(entry.departureAirport ?? "—") - \(entry.destinationAirport ?? "—")")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func detailRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 3)
    }

    private func detailSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(accentHighlight)
                .opacity(0.25)
        }
    }
}

#Preview {
    NavigationStack {
        LogbookDetailView(
            entry: LogbookEntry(
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
        )
    }
}

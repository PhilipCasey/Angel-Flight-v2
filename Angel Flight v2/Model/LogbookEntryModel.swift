//
//  LogbookEntryModel.swift
//  Angel Flight v2
//
//  Created by OpenAI on 2026-04-28.
//

import Foundation

struct LogbookEntry: Codable, Hashable, Identifiable {
    let id: String
    let patientName: String?
    let missionDate: String?
    let missionDayOfWeek: String?
    let completionDate: String?
    let completionDayOfWeek: String?
    let departureCity: String?
    let departureAirport: String?
    let destinationCity: String?
    let destinationAirport: String?
    let totalHoursFlown: String?
    let totalMilesFlown: String?
    let hourlyOperatingCosts: String?
    let additionalExpenses: String?
    let expenseDescription: String?
    let additionalComments: String?

    enum CodingKeys: String, CodingKey {
        case id
        case patientName
        case missionDate = "missiondate"
        case missionDayOfWeek
        case completionDate
        case completionDayOfWeek
        case departureCity
        case departureAirport
        case destinationCity
        case destinationAirport
        case totalHoursFlown
        case totalMilesFlown
        case hourlyOperatingCosts
        case additionalExpenses
        case expenseDescription
        case additionalComments
    }
}

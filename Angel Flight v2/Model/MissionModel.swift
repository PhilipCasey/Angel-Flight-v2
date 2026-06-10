//
//  Mission.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/28/25.
//

import Foundation

struct Mission: Identifiable, Codable {
    let id: String
    let status: MissionStatus
    let patient: Patient
    let mission: MissionInfo
    let route: Route
    let passenger: Passenger
    let baggage: Baggage
    let flightTotals: FlightTotals?
    let expenses: Expenses?
    let comments: String?
    
    var searchableFields: [String] {
        let fields: [String?] = [
            id,
            status.rawValue,
            patient.name,
            patient.care,
            patient.age.map { String($0) },
            patient.weight.map { String($0) },
            mission.date,
            mission.dayOfWeek,
            mission.departureTime,
            mission.completedDate,
            mission.completedDayOfWeek,
            route.departure.city,
            route.departure.state,
            route.departure.airport,
            route.destination.city,
            route.destination.state,
            route.destination.airport,
            passenger.weight.map { String($0) },
            baggage.weight.map { String($0) },
            flightTotals?.hoursFlown.description,
            flightTotals?.milesFlown.description,
            expenses?.hourlyOperatingCost.description,
            expenses?.additionalExpenses.description,
            expenses?.description,
            comments,
            totalWeight
        ]
        return fields.compactMap { $0 }
    }
    
    func matchesSearch(_ searchText: String) -> Bool {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSearchText.isEmpty else { return true }
        return searchableFields.contains {
            $0.localizedCaseInsensitiveContains(trimmedSearchText)
        }
    }
    
    var totalWeight: String {
        let weights = [
            patient.weight,
            passenger.weight,
            baggage.weight
        ]
        // creates array of integers rather than an array of optional integers, adds them
        //map() will take a value out of its container, transform it using the code you specify, then put it back in its container. compactMap() does the same thing, but if your transformation returns an optional it will be unwrapped and have any nil values discarded.
        let totalWeight = weights.compactMap { $0 }.reduce(0, +)
        
        guard totalWeight > 0 else {
            return "N/A"
        }

        return String(Int(totalWeight))
    }
    
    // Sample Mission Data for Available Missions
    static let sampleMissionAvailable = Mission(
        id: "25-0625-01",
        status: .available,
        patient: Patient.init(
            name: nil,
            care: "Transplant-Heart",
            age: 85,
            weight: 230,
        ),
        mission: MissionInfo.init(
            date: "07-28-2025",
            dayOfWeek: "Monday",
            departureTime: "8:00 am",
            completedDate: nil,
            completedDayOfWeek: nil
        ),
        route: Route.init(
            departure: AirportLocation.init(
                city: "Savannah",
                state: "GA",
                airport: "SAV"),
            destination: AirportLocation.init(
                city: "Atlanta",
                state: "GA",
                airport: "PDK")
        ),
        passenger: Passenger.init(
            weight: 146,
        ),
        baggage: Baggage.init(
            weight: 25
        ),
        flightTotals: nil,
        expenses: nil,
        comments: nil
    )
    
    // Sample Mission Data for Available Missions
    static let sampleMissionAccepted = Mission(
        id: "25-0625-01",
        status: .accepted,
        patient: Patient.init(
            name: nil,
            care: "Transplant-Heart",
            age: 85,
            weight: 230,
        ),
        mission: MissionInfo.init(
            date: "07-28-2025",
            dayOfWeek: "Monday",
            departureTime: "8:00 am",
            completedDate: nil,
            completedDayOfWeek: nil
        ),
        route: Route.init(
            departure: AirportLocation.init(
                city: "Savannah",
                state: "GA",
                airport: "SAV"),
            destination: AirportLocation.init(
                city: "Atlanta",
                state: "GA",
                airport: "PDK")
        ),
        passenger: Passenger.init(
            weight: 146,
        ),
        baggage: Baggage.init(
            weight: 25
        ),
        flightTotals: nil,
        expenses: nil,
        comments: nil
    )
    
    
    // Sample Mission Data for Completed Missions
    static let sampleMissionCompleted = Mission(
        id: "23-0501-01",
        status: .completed,
        patient: Patient.init(
            name: "Lori Smith",
            care: nil,
            age: nil,
            weight: nil,
        ),
        mission: MissionInfo.init(
            date: "04-18-2023",
            dayOfWeek: "Tuesday",
            departureTime: nil,
            completedDate: "04-18-2023",
            completedDayOfWeek: "Tuesday"
        ),
        route: Route.init(
            departure: AirportLocation.init(
                city: "Lawrenceville",
                state: "GA",
                airport: "PDK"),
            destination: AirportLocation.init(
                city: "Walterboro",
                state: "SC",
                airport: "RBW")
        ),
        passenger: Passenger.init(
            weight: nil,
        ),
        baggage: Baggage.init(
            weight: nil
        ),
        flightTotals: FlightTotals.init(
            hoursFlown: 4.5,
            milesFlown: 416
        ),
        expenses: nil,
        comments: nil
    )
}

enum MissionStatus: String, Codable {
    case completed
    case accepted
    case available
}

struct Patient: Codable {
    let name: String?
    let care: String?
    let age: Int?
    let weight: Double?
}

struct MissionInfo: Codable {
    let date: String
    let dayOfWeek: String?
    let departureTime: String?
    let completedDate: String?
    let completedDayOfWeek: String?
}

struct Route: Codable {
    let departure: AirportLocation
    let destination: AirportLocation
}

struct AirportLocation: Codable {
    let city: String
    let state: String
    let airport: String
}

struct Passenger: Codable {
    let weight: Double?
}
struct Baggage: Codable {
    let weight: Double?
}

struct FlightTotals: Codable {
    let hoursFlown: Double
    let milesFlown: Double
}

struct Expenses: Codable {
    let hourlyOperatingCost: Double
    let additionalExpenses: Double
    let description: String?
}






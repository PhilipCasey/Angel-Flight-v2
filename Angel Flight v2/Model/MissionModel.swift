//
//  Mission.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/28/25.
//

import SwiftUI

struct Mission: Codable, Hashable {
    
        var id: String? = nil
        var date: String? = nil
        var dayOfWeek: String? = nil
        var departureTime: String? = nil
        var departureCity: String? = nil
        var departureAirport: String? = nil
        var destinationCity: String? = nil
        var destinationAirport: String? = nil
        var patientCare: String? = nil
        var patientAge: String? = nil
        var patientWeight: String? = nil
        var passengerWeight: String? = nil
        var baggageWeight: String? = nil

    var totalWeightText: String {
        let weights = [patientWeight, passengerWeight, baggageWeight]
        let expectedCount = weights.filter { $0 != nil && $0 != "N/A" }.count
        let parsedWeights = weights.compactMap { weight -> Int? in
            guard let weight, weight != "N/A" else {
                return nil
            }

            return Int(weight)
        }

        guard parsedWeights.count == expectedCount else {
            return "loading"
        }

        return String(parsedWeights.reduce(0, +))
    }
    
    static let sampleMission = Mission(
        id: "25-0625-01",
        date: "July 28, 2025",
        dayOfWeek: "Monday",
        departureTime: "8:00 am",
        departureCity: "Savannah, GA",
        departureAirport: "SAV",
        destinationCity: "Atlanta, GA",
        destinationAirport: "PDK",
        patientCare: "Transplant-Heart",
        patientAge: "85",
        patientWeight: "230",
        passengerWeight: "146",
        baggageWeight: "10"
    )

}

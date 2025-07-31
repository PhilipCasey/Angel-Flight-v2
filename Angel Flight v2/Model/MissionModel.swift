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
        var patientWeight: String? = nil
        var passengerWeight: String? = nil
        var baggageWeight: String? = nil
    
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
        patientWeight: "230",
        passengerWeight: "146",
        baggageWeight: "10"
    )

}


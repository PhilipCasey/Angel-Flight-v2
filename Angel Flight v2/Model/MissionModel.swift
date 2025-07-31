//
//  Mission.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/28/25.
//

import SwiftUI

struct MissionData: Codable, Hashable {
    
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

}


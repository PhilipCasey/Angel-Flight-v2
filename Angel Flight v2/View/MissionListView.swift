//
//  ContentView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/26/25.
//

import SwiftUI

let gradientColors: [Color] = [.gradientTop, .gradientBottom]
let accentHighlight: Color = .accentHighlight

struct MissionListView: View {
    var body: some View {
    ZStack {
        VStack(spacing: 12) {
            MissionCardView(
                missionId: "234",
                missionDate: "July 28, 2025",
                missionDayOfWeek: "Monday",
                missionDepartureTime: "8:00 am",
                missionDepartureCity: "Savannah, GA",
                missionDepartureAirport: "SAV",
                missionDestinationCity: "Atlanta, GA",
                missionDestinationAirport: "PDK",
                missionPatientCare: "Transplant-Heart",
                missionPatientWeight: "230",
                missionPassengerWeight: "146",
                missionBaggageWeight: "10")

            /*
            Divider()
                .background(accentHighlight)
                .padding(.horizontal, 100)
        
             */
            

            

            }
        }
        .background(Gradient(colors: gradientColors))
    }
        
}


#Preview {
    MissionListView()
}


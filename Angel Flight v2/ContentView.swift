//
//  ContentView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/26/25.
//

import SwiftUI

let gradientColors: [Color] = [.gradientTop, .gradientBottom]
let accentHighlight: Color = .accentHighlight

struct ContentView: View {
    var body: some View {
    ZStack {
        VStack(spacing: 12) {
            MissionCardView(
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
            MissionCardView(
                missionDate: "July 29, 2025",
                missionDayOfWeek: "Tuesday",
                missionDepartureTime: "Anytime",
                missionDepartureCity: "Newnan, GA",
                missionDepartureAirport: "CCO",
                missionDestinationCity: "Memphis, TN",
                missionDestinationAirport: "M01",
                missionPatientCare: "Cancer",
                missionPatientWeight: "130",
                missionPassengerWeight: "N/A",
                missionBaggageWeight: "10")
            MissionCardView(
                missionDate: "July 30, 2025",
                missionDayOfWeek: "Wednesday",
                missionDepartureTime: "1:30 pm CDT",
                missionDepartureCity: "Nashville, TN",
                missionDepartureAirport: "JWN",
                missionDestinationCity: "Greenville, SC",
                missionDestinationAirport: "GMU",
                missionPatientCare: "Transplant-Heart",
                missionPatientWeight: "230",
                missionPassengerWeight: "130",
                missionBaggageWeight: "15")
            MissionCardView(
                missionDate: "July 31, 2025",
                missionDayOfWeek: "Thursday",
                missionDepartureTime: "Morning",
                missionDepartureCity: "Lawrenceville, GA",
                missionDepartureAirport: "LZU",
                missionDestinationCity: "Augusta, GA",
                missionDestinationAirport: "DNL",
                missionPatientCare: "Burns",
                missionPatientWeight: "220",
                missionPassengerWeight: "N/A",
                missionBaggageWeight: "5")
            }
        }
        .background(Gradient(colors: gradientColors))
    }
        
}


#Preview {
    ContentView()
}

struct MissionCardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let missionDate: String
    let missionDayOfWeek: String
    let missionDepartureTime: String
    let missionDepartureCity: String
    let missionDepartureAirport: String
    let missionDestinationCity: String
    let missionDestinationAirport: String
    let missionPatientCare: String
    let missionPatientWeight: String
    let missionPassengerWeight: String
    let missionBaggageWeight: String
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "globe")
                            Text("25-0625-01")
        
                        }
                        .font(.footnote)
                        .foregroundStyle(Color.secondary)
                        .opacity(0.6)
                        Spacer()
                    }
                    
                    HStack {
                        VStack {
                            VStack {
                                Text(missionDayOfWeek)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.secondary)
                                
                            }
                            VStack {
                                Text(missionDate)
                                    .font(.title2)
                            }
                            VStack {
                                HStack {
                                    Text("Departing")
                                    Text(missionDepartureTime)
                                        .fontWeight(.bold)
                                }
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                    
                }
            }
            HStack {
                VStack {
                    HStack {
                        Text(missionDepartureCity)
                            .font(.callout)
                            .foregroundStyle(Color.secondary)
                    }
                    HStack {
                        Text(missionDepartureAirport)
                            .font(.title)
                    }
                }
                Spacer()
                VStack{
                    HStack{
                        VStack{
                            Image(systemName: "airplane")
                                .font(.title)
                        }
                    }
                }
                Spacer()
                VStack{
                    HStack {
                        Text(missionDestinationCity)
                            .font(.callout)
                            .foregroundStyle(Color.secondary)
                    }
                    HStack{
                        Text(missionDestinationAirport)
                            .font(.title)
                    }
                }
            }
            .padding(12)
            .background {
                 RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(accentHighlight)
                    .opacity(0.25)
             }
            .padding(.vertical, 8)
            HStack{
                VStack{
                    HStack{
                        Image(systemName: "waveform.path.ecg")
                            .font(.footnote)
                        Text(missionPatientCare)
                            .font(.headline)
                        Spacer()
                    }

                    HStack {
                        Image(systemName: "person.fill")
                        Text(missionPatientWeight)
                        
                        if missionPassengerWeight != "N/A" {
                            Image(systemName: "person.2.fill")
                            Text(missionPassengerWeight)
                        }
                        
                        Image(systemName: "suitcase.fill")
                        Text(missionBaggageWeight)
                        Spacer()
                    }
                    .font(.footnote)
                }
                Spacer()
                HStack {
                    Button("View Mission") {
                        
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
            }
            .padding(.leading, 8)
            
        }
        
        .padding(14)
        .background {
            if colorScheme == .light {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.viewBackground)
            }
        }
        .padding(.horizontal, 10)
        
    }
}

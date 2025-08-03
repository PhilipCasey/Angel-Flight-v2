//
//  MissionCardView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/28/25.
//
import SwiftUI

struct MissionCardView: View {
    @Environment(\.colorScheme) var colorScheme
    //@StateObject var missionData = Fetcher()
    let mission: Mission
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    
                    VStack {
                        HStack {
                            Spacer()
                            //Image(systemName: "globe")
                            Text(mission.id ?? "loading")
        
                        }
                        .font(.footnote)
                        .foregroundStyle(Color.secondary)
                        .opacity(0.6)
                        Spacer()
                    }
                    
                    HStack {
                        VStack {
                            VStack {
                                Text(mission.dayOfWeek ?? "loading")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.secondary)
                                
                            }
                            VStack {
                                Text(mission.date ?? "loading")
                                    .font(.title2)
                            }
                            VStack {
                                HStack {
                                    Text("Departing")
                                    Text(mission.departureTime ?? "loading")
                                        .fontWeight(.bold)
                                }
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                    
                }
            }
            // Route
            ZStack {
                VStack {
                    HStack{
                        VStack{
                            Image(systemName: "airplane")
                                .font(.title)
                        }
                    }
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("Departure")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                        
                        Text(mission.departureAirport ?? "loading")
                            .font(.largeTitle)
                        
                        Text(mission.departureCity ?? "loading")
                            .font(.callout)
                            //.foregroundStyle(Color.secondary)
                        
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Destination")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                        Text(mission.destinationAirport ?? "loading")
                            .font(.largeTitle)
                        Text(mission.destinationCity ?? "loading")
                            .font(.callout)
                            //.foregroundStyle(Color.secondary)
                        
                    }
                }
            }
            //.frame(height: 120)
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(accentHighlight)
                    .opacity(0.25)
            }
            .padding(.vertical, 8)
            
            //Patient Details
            HStack{
                VStack{
                    HStack{
                        Image(systemName: "waveform.path.ecg")
                            .font(.footnote)
                        Text(mission.patientCare ?? "loading")
                            .font(.headline)
                        Spacer()
                    }

                    HStack {
                        Image(systemName: "person.fill")
                        Text(mission.patientWeight ?? "loading")
                        
                        if mission.passengerWeight != "N/A" {
                            Image(systemName: "person.2.fill")
                            Text(mission.passengerWeight ?? "loading")
                        }
                        
                        Image(systemName: "suitcase.fill")
                        Text(mission.baggageWeight ?? "loading")
                        Spacer()
                    }
                    .font(.footnote)
                }
                Spacer()
                HStack {
                    //Image(systemName: "globe")
                    //Text(mission.id ?? "loading")
                    Text("View Mission")
                        //.font(.capt)
                    Image(systemName: "chevron.right")
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
        //.frame(minWidth: 350, idealWidth: 380, minHeight: 220, idealHeight: 250, maxHeight: 300)
        
    }
}


#Preview {
    MissionCardView(mission: Mission.sampleMission)
}

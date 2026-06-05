//
//  MissionCardView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/28/25.
//
import SwiftUI

struct MissionCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    //@StateObject var missionData = Fetcher()
    let mission: Mission

    private var shouldShowCondensedWeights: Bool {
        dynamicTypeSize > .xxLarge
    }

    private var shouldStackViewMissionLabel: Bool {
        dynamicTypeSize > .xLarge
    }
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    
                    VStack {
                        HStack {
                            Spacer()
                            //Image(systemName: "globe")
                            Text(mission.id)
        
                        }
                        .font(.footnote)
                        .foregroundStyle(Color.secondary)
                        .opacity(0.6)
                        Spacer()
                    }
                    
                    HStack {
                        VStack {
                            VStack {
                                Text(mission.mission.dayOfWeek)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.secondary)
                                
                            }
                            VStack {
                                Text(mission.mission.date)
                                    .font(.title2)
                            }
                            VStack {
                                HStack {
                                    Text("Departing")
                                    Text(mission.mission.departureTime ?? "loading")
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
                        
                        Text(mission.route.departure.airport)
                            .font(.title)
                        
                        Text("\(mission.route.departure.city), \(mission.route.departure.state)")
                            .font(.callout)
                            //.foregroundStyle(Color.secondary)
                        
                    }
                    
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Destination")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                        Text(mission.route.destination.airport)
                            .font(.title)
                        Text("\(mission.route.destination.city), \(mission.route.destination.state)")
                            .font(.callout)
                            //.foregroundStyle(Color.secondary)
                        
                    }
                }
            }
            //.frame(height: 120)
            .padding(13)
            .background {
                RoundedRectangle(cornerRadius: 14)
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
                        Text(mission.patient.care ?? "loading")
                            .font(.headline)
                        Spacer()
                    }

                    HStack {
                        if shouldShowCondensedWeights {
                            Image(systemName: "birthday.cake")
                            Text(mission.patient.age != nil ? "\(Int(mission.patient.age!)) yrs old" : "loading")
                            
                        } else {
                            Image(systemName: "birthday.cake")
                            Text(mission.patient.age != nil ? "\(Int(mission.patient.age!)) yrs old" : "loading")
                            if mission.passenger.weight != nil {
                                Image(systemName: "person.2.fill")
                                Text("Patient + Passenger")
                            } else {
                                Image(systemName: "person.fill")
                                Text("Patient")
                            }
                        }
                        Spacer()
                    }
                    .font(.subheadline)
                }
                Spacer()
                Group {
                    if shouldStackViewMissionLabel {
                        HStack {
                            VStack{
                                //Text("View")
                                //Text("Mission")
                            }
                            Image(systemName: "chevron.right")
                        }
                    } else {
                        HStack {
                            //Text("View Mission")
                            Image(systemName: "chevron.right")
                        }
                    }
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
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.viewBackground)
            }
        }
        .padding(.horizontal, 10)
        //.frame(minWidth: 350, idealWidth: 380, minHeight: 220, idealHeight: 250, maxHeight: 300)
        
    }
}


#Preview {
    MissionCardView(mission: Mission.sampleMissionAvailable)
}

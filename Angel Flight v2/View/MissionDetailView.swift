//
//  MissionCardView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/28/25.
//
import SwiftUI

struct MissionDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    //@StateObject var missionData = Fetcher()
    let mission: Mission
    
    var body: some View {
        ScrollView{
            VStack {
                // Mission Details
                HStack{
                    VStack {
                        Text("Mission Details")
                            .font(.headline)
                            .padding(7)
                        
                        Divider()
                        .background(accentHighlight)
                        .padding(.horizontal, 75)
                        .padding(.bottom, 5)
                        
                        Text(mission.dayOfWeek ?? "loading")
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                        
                        Text(mission.date ?? "loading")
                            .font(.title)
                        
                        HStack {
                            Text("Departing")
                            Text(mission.departureTime ?? "loading")
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding()
                
                //Route
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
                        VStack{
                            Text("Route")
                            .font(.headline)
                                Spacer()
                            }
                        .padding()
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
                .frame(height: 120)
                .padding(.horizontal, 18)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(accentHighlight)
                        .opacity(0.25)
                }
                //.padding(.vertical, 8)
                
                // Passenger Need
                HStack {
                    VStack{
                        HStack {
                            Text("Patient")
                                .font(.headline)
                        }
                        
                        HStack {
                            Image(systemName: "waveform.path.ecg")
                                .font(.title2)
                                .frame(width: 35, alignment: .trailing)
                            Text(mission.patientCare ?? "loading")
                            
                            Spacer()
                            
                        }.padding(.vertical, 3)
                        
                        HStack {
                            Image(systemName: "birthday.cake")
                                .font(.title2)
                                .frame(width: 35, alignment: .trailing)
                            Text("84 yrs old")
                            
                            Spacer()
                            
                        }.padding(.vertical, 3)
                        
                    }
                    .padding(18)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(accentHighlight)
                            .opacity(0.25)
                    }
                    //.padding(.vertical, 8)
                    
                }
                
                // Payload
                HStack {
                    VStack{
                        HStack {
                            Text("Payload")
                                .font(.headline)
                        }
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.title2)
                                .frame(width: 35, alignment: .trailing)
                            Text("Patient")
                            Spacer()
                            Text("\(mission.patientWeight ?? "loading") lbs")
                        }.padding(.vertical, 3)
                        
                        
                        if mission.passengerWeight != "N/A" {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .font(.title2)
                                    .frame(width: 35, alignment: .trailing)
                                Text("Passenger")
                                Spacer()
                                Text("\(mission.passengerWeight ?? "loading") lbs")
                            }.padding(.vertical, 3)
                        }
                        
                        HStack{
                            Image(systemName: "suitcase.fill")
                                .font(.title2)
                                .frame(width: 35, alignment: .trailing)
                            Text("Baggage")
                            Spacer()
                            Text("\(mission.baggageWeight ?? "loading") lbs")
                        }
                        .padding(.vertical, 3)
                        .padding(.bottom, 3)
                        
                        Divider()
                        
                        HStack{
                            Image(systemName: "scalemass.fill")
                                .font(.title2)
                                .frame(width: 35, alignment: .trailing)
                            Text("Total Weight")
                            Spacer()
                            Text("\(mission.baggageWeight ?? "loading") lbs")
                        }
                        .fontWeight(.bold)
                        .padding(.top, 4)
                        
                    }
                    .padding(18)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(accentHighlight)
                            .opacity(0.25)
                    }
                    //.padding(.vertical, 8)
                    
                }
                
                //Buttons
                HStack {
                    Button {
                        
                    } label: {
                        Label("Open Route in EFB", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                
                HStack {
                    Button {
                        
                    } label: {
                        Label("Accept Mission", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                
                // Mission ID
                HStack {
                    HStack {
                        Image(systemName: "globe")
                        Text(mission.id ?? "loading")
                    }
                    .foregroundStyle(Color.secondary)
                }
                .padding()
                
                
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
        .scrollContentBackground(.hidden)
        .background(Gradient(colors: gradientColors))
        //.toolbar(.hidden, for: .tabBar)
    }
       
}


#Preview {
    MissionDetailView(mission: Mission.sampleMission)
}

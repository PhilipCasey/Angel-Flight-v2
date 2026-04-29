//
//  MissionCardView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/28/25.
//
import SwiftUI
import UIKit

struct MissionDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    //@StateObject var missionData = Fetcher()
    let mission: Mission
    @State private var sharedFile: SharedFile?
    @State private var errorMessage = ""
    @State private var isShowingError = false
    
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Rectangle()
                    .fill(Gradient(colors: gradientColors))
                    .ignoresSafeArea()
            } else {
                Color.white
                    .ignoresSafeArea()
            }

            ScrollView{
                VStack {
                // Mission Details
                HStack{
                    VStack(spacing: 2) {
                        
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
                .padding(.bottom)
                
                //Route Section
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
                
                // Patient Section
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
                            Text("\(mission.patientAge ?? "loading") yrs old")
                            
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
                
                // Payload Section
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
                            Text("\(mission.totalWeightText) lbs")
                            //Text("\(mission.baggageWeight ?? "loading") lbs")
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
                    .padding(.bottom, 8)
                    
                }
                
                //Buttons
                HStack {
                    Button {
                        openRouteInEFB()
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
                .padding(.horizontal, 5)
            }
        }
        .navigationTitle("Mission Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $sharedFile) { sharedFile in
            ShareSheet(activityItems: [sharedFile.url])
        }
        .alert("Unable to Create Flight Plan", isPresented: $isShowingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    private func openRouteInEFB() {
        do {
            sharedFile = SharedFile(url: try FPLGenerator.generateFile(for: mission))
        } catch {
            errorMessage = error.localizedDescription
            isShowingError = true
        }
    }
}

private struct SharedFile: Identifiable {
    let id = UUID()
    let url: URL
}

private struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}


#Preview {
    MissionDetailView(mission: Mission.sampleMission)
}

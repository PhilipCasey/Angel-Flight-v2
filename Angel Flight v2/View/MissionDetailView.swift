//
//  MissionCardView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/28/25.
//
import SwiftUI

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
                        
                        Text(mission.mission.dayOfWeek ?? "")
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                        
                        Text(mission.mission.date)
                            .font(.title)
                        
                        HStack {
                            Text("Departing")
                            Text(mission.mission.departureTime ?? "loading")
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
                            
                            Text(mission.route.departure.airport)
                                .font(.largeTitle)
                            
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
                                .font(.largeTitle)
                            Text("\(mission.route.destination.city), \(mission.route.destination.state)")
                                .font(.callout)
                                //.foregroundStyle(Color.secondary)
                            
                        }
                    }
                }
                .frame(height: 120)
                .padding(.horizontal, 18)
                .background {
                    RoundedRectangle(cornerRadius: 14)
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
                                .font(.title3)
                                .frame(width: 35, alignment: .trailing)
                            Text(mission.patient.care ?? "loading")
                            
                            Spacer()
                            
                        }.padding(.vertical, 3)
                        
                        HStack {
                            Image(systemName: "birthday.cake")
                                .font(.title3)
                                .frame(width: 35, alignment: .trailing)
                            Text(mission.patient.age != nil ? "\(Int(mission.patient.age!)) years old" : "loading")
                            
                            Spacer()
                            
                        }.padding(.vertical, 3)
                        
                    }
                    .padding(18)
                    .background {
                        RoundedRectangle(cornerRadius: 14)
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
                                .font(.title3)
                                .frame(width: 35, alignment: .trailing)
                            Text("Patient")
                            Spacer()
                            Text(mission.patient.weight != nil ? "\(Int(mission.patient.weight!)) lbs" : "loading")
                        }.padding(.vertical, 3)
                        
                        
                        if mission.passenger.weight != nil {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .font(.title3)
                                    .frame(width: 35, alignment: .trailing)
                                Text("Passenger")
                                Spacer()
                                Text(mission.passenger.weight != nil ? "\(Int(mission.passenger.weight!)) lbs" : "loading")
                            }.padding(.vertical, 3)
                        }
                        
                        HStack{
                            Image(systemName: "suitcase.fill")
                                .font(.title3)
                                .frame(width: 35, alignment: .trailing)
                            Text("Baggage")
                            Spacer()
                            Text(mission.baggage.weight != nil ? "\(Int(mission.baggage.weight!)) lbs" : "loading")
                        }
                        .padding(.vertical, 3)
                        .padding(.bottom, 3)
                        
                        Divider()
                        
                        HStack{
                            Image(systemName: "scalemass.fill")
                                .font(.title3)
                                .frame(width: 35, alignment: .trailing)
                            Text("Total Weight")
                            Spacer()
                            Text("\(mission.totalWeight) lbs")
                        }
                        .fontWeight(.bold)
                        .padding(.top, 4)
                        
                    }
                    .padding(18)
                    .background {
                        RoundedRectangle(cornerRadius: 14)
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
                        Text(mission.id)
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
    MissionDetailView(mission: Mission.sampleMissionAvailable)
}

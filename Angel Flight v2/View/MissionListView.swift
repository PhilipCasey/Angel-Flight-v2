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
    @StateObject var missionData = Fetcher()
    var body: some View {
        
        ZStack {
            NavigationStack {
                
                List {

                        ForEach(missionData.missions, id: \.id){ mission in
                                                            
                            MissionCardView(mission: mission)
                                .background(
                                    NavigationLink(destination: MissionDetailView(mission: mission)) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                )
                    
                            Divider()
                            .background(accentHighlight)
                            .padding(.horizontal, 100)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets()) // Removes default padding
                        .listRowBackground(Color.clear) // Makes background transparent
                    
                
                }
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
                .background(Gradient(colors: gradientColors))
                .navigationTitle("Missions")
                .onAppear {
                    missionData.fetcher()
                }
            }

        }

        
        
    }
}

#Preview {
    MissionListView()
}


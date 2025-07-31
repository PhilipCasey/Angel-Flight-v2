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
        NavigationView {
            List {
                ForEach(missionData.missions, id: \.id){ mission in
                    MissionCardView(mission: mission)
                }
            }
            .navigationTitle("Missions")
            .onAppear {
                missionData.fetcher()
            }
            
            /*
             Divider()
             .background(accentHighlight)
             .padding(.horizontal, 100)
             
             */

            .background(Gradient(colors: gradientColors))
        }
        
    }
}

#Preview {
    MissionListView()
}


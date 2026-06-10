//
//  ListView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 6/4/26.
//

import SwiftUI

struct FilteredListCardView: View {
    let missions: [Mission]
    let status: MissionStatus
    let searchText: String
    
    init(missions: [Mission], status: MissionStatus, searchText: String = "") {
        self.missions = missions
        self.status = status
        self.searchText = searchText
    }
    
    var filteredMissions: [Mission] {
        missions.filter { mission in
            mission.status == status && mission.matchesSearch(searchText)
        }
    }
    
    var body: some View {

        ForEach(filteredMissions) { mission in
                MissionCardView(mission: mission)
                    .background(
                        NavigationLink(destination: MissionDetailView(mission: mission)) {
                            EmptyView()
                        }
                            .opacity(0)
                    )
                    .padding(8)
                
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets()) // Removes default padding
            .listRowBackground(Color.clear)
        }
}

//
//  MissionDetailView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/31/25.
//

import SwiftUI

struct MissionDetailView: View {
    @StateObject var missionData = Fetcher()
    let mission: Mission
    
    var body: some View {
        Text(mission.id ?? "loading")
    }
}

#Preview {
    MissionDetailView(mission: Mission.sampleMission)
}

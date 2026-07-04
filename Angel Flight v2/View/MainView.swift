//
//  MainView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/31/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var missionData = Fetcher()

    private var acceptedMissionCount: Int {
        missionData.missions.filter { $0.status == .accepted }.count
    }

    var body: some View {
        TabView {
            NavigationStack {
                MissionListViewAvailable()
            }
            .tabItem() {
                Label("Missions", systemImage: "waveform.path.ecg")
            }
            .tag(0)
            
            NavigationStack {
                MissionListViewAccepted()
            }
            .tabItem {
                Label("Accepted", systemImage: "paperplane.fill")
            }
            .badge(acceptedMissionCount)
            
            NavigationStack {
                LogbookListView()
            }
            .tabItem {
                Label("Logbook", systemImage: "book")
            }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .onAppear {
            missionData.fetcher()
        }
    }
}

#Preview {
    MainView()
}

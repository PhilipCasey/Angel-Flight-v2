//
//  MainView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/31/25.
//

import SwiftUI


struct MainView: View {

    var body: some View {
        NavigationStack {
            TabView {
                MissionListView()
                    .tabItem() {
                        Label("Missions", systemImage: "globe")
                    }
                Text("Accepted Missions")
                    .tabItem {
                        Label("Accepted", systemImage: "paperplane.fill")
                    }
                    .badge(3)
                
                LogbookListView()
                    .tabItem {
                        Label("Logbook", systemImage: "book")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
        }
    }
}

#Preview {
    MainView()
}

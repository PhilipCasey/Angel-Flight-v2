//
//  MainView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/31/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            MissionListView()
                .tabItem() {
                    Label("Missions", systemImage: "globe")
                }
            Text("Logbook")
                .tabItem {
                    Label("Logbook", systemImage: "book")
                }
                
        }
    }
}

#Preview {
    MainView()
}

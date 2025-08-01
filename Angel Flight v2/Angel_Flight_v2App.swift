//
//  Angel_Flight_v2App.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/26/25.
//

import SwiftUI

@main
struct Angel_Flight_v2App: App {
    @StateObject var missionData = Fetcher() //This is what made the #preview start working
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(missionData)
        }
    }
}


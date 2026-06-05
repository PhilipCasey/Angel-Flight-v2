//
//  ContentView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/26/25.
//

import SwiftUI

let gradientColors: [Color] = [.gradientTop, .gradientBottom]
let accentHighlight: Color = .accentHighlight

struct MissionListViewAvailable: View {
    @StateObject var missionData = Fetcher()

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white] // NavigationTitle Color
    }

    var body: some View {
        List {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 75)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 36)
                .padding(.bottom, 7)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .stretchy()

            //listView(MissionStatus: .accepted) // Builds the list cardview
            FilteredListCardView(
                missions: missionData.missions,
                status: .available
            )
            
            Text("Thank you for serving!")
                .foregroundStyle(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
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

#Preview {
    MissionListViewAvailable()
}

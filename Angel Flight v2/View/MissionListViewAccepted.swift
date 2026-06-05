
//
//  MissionListViewAvailable 2.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 6/4/26.
//


import SwiftUI

struct MissionListViewAccepted: View {
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
            
            Text("Your Missions")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

            // Builds the list cardview
            FilteredListCardView(
                missions: missionData.missions,
                status: .accepted
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
    MissionListViewAccepted()
}

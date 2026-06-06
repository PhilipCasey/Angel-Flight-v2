//
//  SettingsView.swift
//  Angel Flight v2
//
//  Created by OpenAI on 2026-04-28.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage(FlightPlanSettings.includeHomeAirportKey) private var includeHomeAirport = false
    @AppStorage(FlightPlanSettings.homeAirportCodeKey) private var homeAirportCode = ""

    var body: some View {
        NavigationStack {
            ZStack {
                if colorScheme == .dark {
                    Rectangle()
                        .fill(Gradient(colors: gradientColors))
                        .ignoresSafeArea()
                } else {
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea()
                }

                Form {
                    Section {
                        LabeledContent("Home Airport") {
                            TextField("Airport Code", text: $homeAirportCode)
                                .multilineTextAlignment(.trailing)
                                .textInputAutocapitalization(.characters)
                                .autocorrectionDisabled()
                                .disabled(!includeHomeAirport)
                        }

                        Toggle("Add to Flight Plan", isOn: $includeHomeAirport)
                    } header: {
                    Text("Flight Plan")
                    } footer: {
                        Text("When enabled, exported flight plans will start and end at your home airport.")
                    }
                    
                    .listRowBackground(rowBackground)
                }
                
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
        }
    }

    private var rowBackground: Color {
        colorScheme == .dark ? Color(red: 0.10, green: 0.15, blue: 0.22) : Color(.secondarySystemGroupedBackground)
    }
}

#Preview {
    SettingsView()
}

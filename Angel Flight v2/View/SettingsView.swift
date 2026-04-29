//
//  SettingsView.swift
//  Angel Flight v2
//
//  Created by OpenAI on 2026-04-28.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(FlightPlanSettings.includeHomeAirportKey) private var includeHomeAirport = false
    @AppStorage(FlightPlanSettings.homeAirportCodeKey) private var homeAirportCode = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Flight Plans") {
                    Toggle("Include Home Airport", isOn: $includeHomeAirport)

                    TextField("Home Airport", text: $homeAirportCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .disabled(!includeHomeAirport)
                }

                Section {
                    Text("When enabled, exported flight plans will start and end at your home airport.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

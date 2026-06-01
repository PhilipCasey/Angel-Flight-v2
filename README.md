# Angel Flight v2

Angel Flight v2 is a redesigned SwiftUI iOS app for browsing [Angel Flight Soars](https://www.angelflightsoars.org) mission opportunities, reviewing completed mission logbook entries, and exporting Garmin-compatible flight plan files for electronic flight bag (ForeFlight & Garmin Pilot) workflows.

## Features

- Browse available missions with route, date, departure time, patient care, and payload details.
- View mission details including departure and destination airports, patient information, passenger and baggage weights, and total payload.
- Export a Garmin `.fpl` flight plan from a mission route and share it to an EFB or another app.
- Optionally include a configured home airport at the start and end of exported flight plans.
- Review logbook summaries by time range, including all entries, last 7 days, last 30 days, last 90 days, last 6 months, and last 12 months.
- Open individual logbook entries with route, flight time, mileage, cost, expense, and notes details.
- Load mission and logbook JSON from GitHub with bundled JSON fallback data for offline or failed-network cases.

## Screenshots

Screenshots are stored in `Angel Flight v2/Docs/Screenshots/`.

| Old | New |
| --- | --- |
| <img src="Angel%20Flight%20v2/Docs/Screenshots/before01.jpg" alt="Old app screen 1" width="360"> | <img src="Angel%20Flight%20v2/Docs/Screenshots/new01.jpg" alt="New app screen 1" width="360"> |
| <img src="Angel%20Flight%20v2/Docs/Screenshots/before02.jpg" alt="Old app screen 2" width="360"> | <img src="Angel%20Flight%20v2/Docs/Screenshots/new02.jpg" alt="New app screen 2" width="360"> |

| Light | Dark |
| --- | --- |
| <img src="Angel%20Flight%20v2/Docs/Screenshots/new01.jpg" alt="New app light screen 1" width="360"> | <img src="Angel%20Flight%20v2/Docs/Screenshots/new01-dark.jpg" alt="New app dark screen 1" width="360"> |
| <img src="Angel%20Flight%20v2/Docs/Screenshots/new02.jpg" alt="New app light screen 2" width="360"> | <img src="Angel%20Flight%20v2/Docs/Screenshots/new02-dark.jpg" alt="New app dark screen 2" width="360"> |

| Flight Plan Exporter | Share to EFB | Route Loads in EFB
| --- | --- | --- |
| <img src="Angel%20Flight%20v2/Docs/Screenshots/new02-action.jpg" alt="New app screen 2" width="260"> | <img src="Angel%20Flight%20v2/Docs/Screenshots/new03-action.jpg" alt="New app screen 3" width="260"> | <img src="Angel%20Flight%20v2/Docs/Screenshots/new04-action.jpg" alt="New app screen 4" width="260"> |

## Project Structure

```text
Angel Flight v2/
+-- Angel Flight v2/
|   +-- Model/
|   |   +-- FPLGeneratorModel.swift
|   |   +-- LogbookEntryModel.swift
|   |   +-- MissionModel.swift
|   |   +-- ViewModel.swift
|   |   +-- us-airports.csv
|   +-- View/
|   |   +-- LogbookDetailView.swift
|   |   +-- LogbookListView.swift
|   |   +-- MainView.swift
|   |   +-- MissionCardView.swift
|   |   +-- MissionDetailView.swift
|   |   +-- MissionListView.swift
|   |   +-- SettingsView.swift
|   |   +-- Stretchy.swift
|   +-- Angel_Flight_v2App.swift
|   +-- Assets.xcassets
|   +-- missionData.json
|   +-- missionLog.json
+-- Products/
```

## Data Sources

The app uses `Fetcher` to load:

- `missionData.json` for available missions.
- `missionLog.json` for completed logbook entries.

Remote data is requested from the GitHub repository first. If the network request fails, returns a non-success HTTP status, or the response cannot be decoded, the app falls back to the bundled JSON files.

Airport lookup data for flight-plan export is bundled in `Model/us-airports.csv`.

## Flight Plan Export

`FPLGenerator` creates Garmin FlightPlan XML files with a `.fpl` extension. Mission routes normally export as:

```text
Departure Airport -> Destination Airport
```

When the setting `Include Home Airport` is enabled and a home airport code is provided, routes export as:

```text
Home Airport -> Departure Airport -> Destination Airport -> Home Airport
```

The generated file is written to the temporary directory and presented through the iOS share sheet from the mission detail screen.

## Requirements

- Xcode
- iOS target supported by the project
- SwiftUI
- Internet access for live GitHub JSON data, unless using bundled fallback data

## Running the App

1. Open the project in Xcode.
2. Select the `Angel Flight v2` scheme.
3. Choose an iOS simulator or connected device.
4. Build and run with `Command-R`.

## Key Screens

- `MissionListView`: Displays available missions.
- `MissionDetailView`: Shows mission details and exports `.fpl` route files.
- `LogbookListView`: Shows logbook totals and filtered entry lists.
- `LogbookDetailView`: Shows detailed completed mission information.
- `SettingsView`: Stores flight-plan export preferences.

## Notes

- Mission and logbook dates are expected in the format `MMMM d, yyyy`.
- Airport codes are normalized to uppercase before flight-plan generation.
- Flight-plan export depends on matching airport codes in `us-airports.csv`.

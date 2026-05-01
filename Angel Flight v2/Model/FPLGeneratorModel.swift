//
//  FPLExporter.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 4/28/26.
//

import Foundation

struct FlightPlanSettings {
    static let includeHomeAirportKey = "includeHomeAirportInFlightPlan"
    static let homeAirportCodeKey = "homeAirportCode"

    let includeHomeAirport: Bool
    let homeAirportCode: String?

    static func load() -> FlightPlanSettings {
        let defaults = UserDefaults.standard
        let homeAirportCode = defaults.string(forKey: homeAirportCodeKey)?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return FlightPlanSettings(
            includeHomeAirport: defaults.bool(forKey: includeHomeAirportKey),
            homeAirportCode: homeAirportCode?.isEmpty == true ? nil : homeAirportCode?.uppercased()
        )
    }
}

enum FPLGeneratorError: LocalizedError {
    case missingAirportCode(String)
    case airportNotFound(String)
    case airportDataUnavailable
    case invalidAirportData(String)
    case fileWriteFailed

    var errorDescription: String? {
        switch self {
        case .missingAirportCode(let field):
            return "Missing \(field) airport code."
        case .airportNotFound(let code):
            return "Could not find airport data for \(code)."
        case .airportDataUnavailable:
            return "The airport reference data is unavailable."
        case .invalidAirportData(let code):
            return "Airport data for \(code) is incomplete."
        case .fileWriteFailed:
            return "The flight plan file could not be created."
        }
    }
}

struct FPLGenerator {
    struct Airport {
        let ident: String
        let exportIdentifier: String
        let latitude: String
        let longitude: String
    }

    static func generateFile(for mission: Mission) throws -> URL {
        guard let departureCode = normalizedCode(from: mission.departureAirport) else {
            throw FPLGeneratorError.missingAirportCode("departure")
        }

        guard let destinationCode = normalizedCode(from: mission.destinationAirport) else {
            throw FPLGeneratorError.missingAirportCode("destination")
        }

        let airportIndex = try loadAirportIndex()
        let departure = try airport(for: departureCode, using: airportIndex)
        let destination = try airport(for: destinationCode, using: airportIndex)
        let settings = FlightPlanSettings.load()

        let routeAirports: [Airport]
        if settings.includeHomeAirport {
            guard let homeAirportCode = settings.homeAirportCode else {
                throw FPLGeneratorError.missingAirportCode("home")
            }

            let homeAirport = try airport(for: homeAirportCode, using: airportIndex)
            routeAirports = [homeAirport, departure, destination, homeAirport]
        } else {
            routeAirports = [departure, destination]
        }

        let xml = flightPlanXML(for: routeAirports)
        let fileName = routeAirports.map(\.exportIdentifier).joined(separator: "-") + ".fpl"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        guard let data = xml.data(using: .utf8) else {
            throw FPLGeneratorError.fileWriteFailed
        }

        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            throw FPLGeneratorError.fileWriteFailed
        }

        return fileURL
    }

    private static func normalizedCode(from value: String?) -> String? {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
            return nil
        }

        return value.uppercased()
    }

    private static func airport(for code: String, using airportIndex: [String: Airport]) throws -> Airport {
        guard let airport = airportIndex[code] else {
            throw FPLGeneratorError.airportNotFound(code)
        }

        return airport
    }

    private static func loadAirportIndex() throws -> [String: Airport] {
        guard let csvURL = Bundle.main.url(forResource: "us-airports", withExtension: "csv") else {
            throw FPLGeneratorError.airportDataUnavailable
        }

        let csvText: String
        do {
            csvText = try String(contentsOf: csvURL, encoding: .utf8)
        } catch {
            throw FPLGeneratorError.airportDataUnavailable
        }

        let rows = csvText.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard let headerRow = rows.first else {
            throw FPLGeneratorError.airportDataUnavailable
        }

        let headers = parseCSVRow(headerRow)
        let headerIndex = Dictionary(uniqueKeysWithValues: headers.enumerated().map { ($0.element, $0.offset) })
        let requiredHeaders = ["ident", "gps_code", "icao_code", "iata_code", "local_code", "latitude_deg", "longitude_deg"]

        guard requiredHeaders.allSatisfy({ headerIndex[$0] != nil }) else {
            throw FPLGeneratorError.airportDataUnavailable
        }

        var airportIndex: [String: Airport] = [:]

        for row in rows.dropFirst() {
            let columns = parseCSVRow(row)
            guard columns.count >= headers.count else {
                continue
            }

            guard
                let ident = value(for: "ident", in: columns, using: headerIndex),
                let exportIdentifier = preferredExportIdentifier(in: columns, using: headerIndex),
                let latitude = value(for: "latitude_deg", in: columns, using: headerIndex),
                let longitude = value(for: "longitude_deg", in: columns, using: headerIndex)
            else {
                continue
            }

            let airport = Airport(
                ident: ident,
                exportIdentifier: exportIdentifier,
                latitude: latitude,
                longitude: longitude
            )

            for codeField in ["ident", "gps_code", "icao_code", "iata_code", "local_code"] {
                if let code = value(for: codeField, in: columns, using: headerIndex) {
                    airportIndex[code] = airport
                }
            }
        }

        return airportIndex
    }

    private static func preferredExportIdentifier(
        in columns: [String],
        using headerIndex: [String: Int]
    ) -> String? {
        for header in ["icao_code", "local_code", "gps_code", "ident"] {
            if let value = value(for: header, in: columns, using: headerIndex) {
                return value
            }
        }

        return nil
    }

    private static func value(
        for header: String,
        in columns: [String],
        using headerIndex: [String: Int]
    ) -> String? {
        guard let index = headerIndex[header], columns.indices.contains(index) else {
            return nil
        }

        let value = columns[index].trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value.uppercasedIfCode(header)
    }

    private static func parseCSVRow(_ row: String) -> [String] {
        var values: [String] = []
        var currentValue = ""
        var isInsideQuotes = false
        let characters = Array(row)
        var index = 0

        while index < characters.count {
            let character = characters[index]

            if character == "\"" {
                if isInsideQuotes, index + 1 < characters.count, characters[index + 1] == "\"" {
                    currentValue.append("\"")
                    index += 1
                } else {
                    isInsideQuotes.toggle()
                }
            } else if character == ",", !isInsideQuotes {
                values.append(currentValue)
                currentValue = ""
            } else {
                currentValue.append(character)
            }

            index += 1
        }

        values.append(currentValue)
        return values
    }

    private static func flightPlanXML(for routeAirports: [Airport]) -> String {
        let waypointXML = uniqueAirports(in: routeAirports).map { airport in
            """
                <waypoint>
                    <identifier>\(airport.exportIdentifier)</identifier>
                    <lat>\(airport.latitude)</lat>
                    <lon>\(airport.longitude)</lon>
                    <type>AIRPORT</type>
                </waypoint>
            """
        }
        .joined(separator: "\n\n")

        let routePointXML = routeAirports.map { airport in
            """
                <route-point>
                    <waypoint-identifier>\(airport.exportIdentifier)</waypoint-identifier>
                    <waypoint-type>AIRPORT</waypoint-type>
                </route-point>
            """
        }
        .joined(separator: "\n\n")

        let routeName = routeAirports.map(\.exportIdentifier).joined(separator: " TO ")

        return """
        <?xml version="1.0" encoding="utf-8"?>
        <flight-plan xmlns="http://www8.garmin.com/xmlschemas/FlightPlan/v1">
        <flight-data>
                <etd-zulu></etd-zulu>
        </flight-data>
        <waypoint-table>
        \(waypointXML)

        </waypoint-table>
        <route>
            <route-name>\(routeName)</route-name>
            <flight-plan-index>1</flight-plan-index>
        \(routePointXML)

        </route>
        </flight-plan>
        """
    }

    private static func uniqueAirports(in routeAirports: [Airport]) -> [Airport] {
        var seenIdentifiers = Set<String>()
        var uniqueAirports: [Airport] = []

        for airport in routeAirports {
            if seenIdentifiers.insert(airport.exportIdentifier).inserted {
                uniqueAirports.append(airport)
            }
        }

        return uniqueAirports
    }
}

private extension String {
    func uppercasedIfCode(_ header: String) -> String {
        switch header {
        case "ident", "gps_code", "icao_code", "iata_code", "local_code":
            return uppercased()
        default:
            return self
        }
    }
}

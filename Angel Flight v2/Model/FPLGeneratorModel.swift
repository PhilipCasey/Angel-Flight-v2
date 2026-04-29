//
//  FPLExporter.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 4/28/26.
//

import Foundation

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

        let xml = flightPlanXML(departure: departure, destination: destination)
        let fileName = "\(departure.exportIdentifier)-\(destination.exportIdentifier).fpl"
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

    private static func flightPlanXML(departure: Airport, destination: Airport) -> String {
        """
        <?xml version="1.0" encoding="utf-8"?>
        <flight-plan xmlns="http://www8.garmin.com/xmlschemas/FlightPlan/v1">
        <flight-data>
                <etd-zulu></etd-zulu>
        </flight-data>
        <waypoint-table>

            <waypoint>
                <identifier>\(departure.exportIdentifier)</identifier>
                <lat>\(departure.latitude)</lat>
                <lon>\(departure.longitude)</lon>
                <type>AIRPORT</type>
            </waypoint>

            <waypoint>
                <identifier>\(destination.exportIdentifier)</identifier>
                <lat>\(destination.latitude)</lat>
                <lon>\(destination.longitude)</lon>
                <type>AIRPORT</type>
            </waypoint>

        </waypoint-table>
        <route>
            <route-name>\(departure.exportIdentifier) TO \(destination.exportIdentifier)</route-name>
            <flight-plan-index>1</flight-plan-index>

            <route-point>
                <waypoint-identifier>\(departure.exportIdentifier)</waypoint-identifier>
                <waypoint-type>AIRPORT</waypoint-type>
            </route-point>

            <route-point>
                <waypoint-identifier>\(destination.exportIdentifier)</waypoint-identifier>
                <waypoint-type>AIRPORT</waypoint-type>
            </route-point>

        </route>
        </flight-plan>
        """
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

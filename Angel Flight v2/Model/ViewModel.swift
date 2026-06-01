import SwiftUI

class Fetcher: ObservableObject {
    @Published var missions: [Mission] = []
    @Published var logbookEntries: [LogbookEntry] = []

    private let missionURLString = "https://raw.githubusercontent.com/PhilipCasey/Angel-Flight-v2/refs/heads/main/Angel%20Flight%20v2/missionData.json"
    private let missionLogURLString = "https://raw.githubusercontent.com/PhilipCasey/Angel-Flight-v2/refs/heads/main/Angel%20Flight%20v2/missionLog.json"

    func fetcher() {
        fetchData(
            from: missionURLString,
            bundleResource: "missionData",
            fileExtension: "json"
        ) { [weak self] data in
            self?.decodeOrFallback(
                data: data,
                as: [Mission].self,
                bundleResource: "missionData",
                fileExtension: "json"
            ) { missions in
                self?.missions = missions
            }
        }
    }

    func fetchMissionLog() {
        fetchData(
            from: missionLogURLString,
            bundleResource: "missionLog",
            fileExtension: "json"
        ) { [weak self] data in
            self?.decodeOrFallback(
                data: data,
                as: [LogbookEntry].self,
                bundleResource: "missionLog",
                fileExtension: "json"
            ) { entries in
                self?.logbookEntries = entries
            }
        }
    }

    private func fetchData(
        from urlString: String,
        bundleResource: String,
        fileExtension: String,
        completion: @escaping (Data) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            loadBundledJSON(named: bundleResource, fileExtension: fileExtension, completion: completion)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if
                let data,
                error == nil,
                let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode
            {
                completion(data)
            } else {
                self.loadBundledJSON(named: bundleResource, fileExtension: fileExtension, completion: completion)
            }
        }

        task.resume()
    }

    private func loadBundledJSON(
        named resource: String,
        fileExtension: String,
        completion: @escaping (Data) -> Void
    ) {
        guard let url = Bundle.main.url(forResource: resource, withExtension: fileExtension) else {
            return
        }

        do {
            let data = try Data(contentsOf: url)
            completion(data)
        } catch {
            print(error)
        }
    }

    private func decodeOrFallback<T: Decodable>(
        data: Data,
        as type: T.Type,
        bundleResource: String,
        fileExtension: String,
        assign: @escaping (T) -> Void
    ) {
        do {
            let decoded = try JSONDecoder().decode(type, from: data)
            DispatchQueue.main.async {
                assign(decoded)
            }
        } catch {
            print(error)
            loadBundledJSON(named: bundleResource, fileExtension: fileExtension) { fallbackData in
                do {
                    let decoded = try JSONDecoder().decode(type, from: fallbackData)
                    DispatchQueue.main.async {
                        assign(decoded)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

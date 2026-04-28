import SwiftUI
class Fetcher: ObservableObject {
    @Published var missions: [Mission] = []
    let urlString = "https://raw.githubusercontent.com/PhilipCasey/Angel-Flight-v2/refs/heads/main/Angel%20Flight%20v2/missionData.json"
    
    func fetcher(){
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let missions = try JSONDecoder().decode([Mission].self, from: data)
                DispatchQueue.main.async {
                    self?.missions = missions
                }
            }
            catch {
                print(error)
            }
        }
            task.resume()
        }
    }




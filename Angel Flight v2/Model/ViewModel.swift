import SwiftUI
class Fetcher: ObservableObject {
    @Published var missions: [Mission] = []
    let urlString = "https://static.showit.co/file/h5OmVF9J-VMpWscsTRNCIg/84162/missiondata.json"
   
    
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




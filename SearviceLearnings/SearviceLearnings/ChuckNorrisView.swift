import SwiftUI

struct ChukNorris: Codable {
    let categories: [String]
    let createdAt: String
    let iconURL: URL
    let id: String
    let updatedAt: String
    let url: URL
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case categories
        case createdAt = "created_at"
        case iconURL = "icon_url"
        case id
        case updatedAt = "updated_at"
        case url
        case value
    }
}

class ChukNorrisService: ObservableObject {
    @Published var jokeData: ChukNorris?
    
    func fetchData() {
        let urlString = "https://api.chucknorris.io/jokes/random"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let jokeData = try JSONDecoder().decode(ChukNorris.self, from: data)
                DispatchQueue.main.async {
                    self.jokeData = jokeData
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct ChuckNorrisView: View {
    @ObservedObject var chuckNorrisService = ChukNorrisService()
    
    var body: some View {
        VStack {
            if let joke = chuckNorrisService.jokeData {
                Text(joke.value)
                    .padding()
            } else {
                Text("Loading...")
                    .padding()
            }
            Button(action: {
                chuckNorrisService.fetchData()
            }) {
                Text("Get New Joke")
            }
        }
    }
}

struct ChuckNorrisAnotherView: View{
    
    @ObservedObject var serviceObject = ChukNorrisService()
    var body: some View{
        VStack{
            
            if let jokeData = serviceObject.jokeData {
                Text(jokeData.value)
            } else {
                Text("Press the button, NOW!")
            }
            
            Button("Get New Joke") {
                serviceObject.fetchData()
            }
        }
    }
}


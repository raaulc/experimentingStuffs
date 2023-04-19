//
//  JokeView.swift
//  SearviceLearnings
//
//  Created by Rahul Rathod on 17/04/2023.
//

import Foundation
import SwiftUI

struct Joke: Codable {
    
    let JokeData: [Joke]
    
    struct Joke: Codable {
        let type: String
        let setup: String
        let punchline: String
        let id: Int
    }
}

class JokeService: ObservableObject {
    let urlString = "url goes here"
    
    func fetchData(completion:@escaping(Result<Joke,Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "error in url", code: 404, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url){ data,response,error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            do{
                let jokeData = try JSONDecoder().decode(Joke.self, from: data)
                completion(.success(jokeData))
            }
            catch{
                completion(.failure(error))
            }
        }.resume()
    }
}

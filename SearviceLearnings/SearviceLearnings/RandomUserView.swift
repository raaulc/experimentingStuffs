//
//  RandomUserView.swift
//  SearviceLearnings
//
//  Created by Rahul Rathod on 17/04/2023.
//

import Foundation
import SwiftUI

struct RandomUser: Codable {
    let Result: [Result]
    let info: Info
    
    struct Result: Codable {
        let name: Name
        let phone: String
        let email: String
        let picture: Picture
        
        struct Name: Codable {
            let title: String
            let first: String
            let last: String
        }
        
        struct Picture: Codable {
            let large: URL
            let medium: URL
            let thumbnail: URL
        }
    }
    
    struct Info: Codable {
        let seed : String
        let results: Int
        let version: String
    }
}

class RandomUserService: ObservableObject{
    
    @Published var userData: RandomUser?
    
    func fetchData(completion:@escaping(Result<RandomUser,Error>) -> Void) {
        
        let urlString = "myURLString"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "issue in url", code: 404, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data,response,error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            do{
                let userData = try JSONDecoder().decode(RandomUser.self, from: data)
                completion(.success(userData))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

//
//  GithubView.swift
//  SearviceLearnings
//
//  Created by Rahul Rathod on 17/04/2023.
//

import Foundation
import SwiftUI


struct Github: Codable {
    let name: String
    let fork: Bool
    
    let owner: Owner
    
    struct Owner: Codable {
        let type: String
        let siteAdmin: Bool
        let avatarURL: URL
        
        enum CodingKeys: String, CodingKey {
            case avatarURL = "avatar_url"
            case type
            case siteAdmin = "site_admin"
        }
    }
}

class GithubService: ObservableObject {
    
    let urlString = "url goes here"
    
    func fetchData(completion:@escaping(Result<Github,Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "url issue", code: 404, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url){ data,response,error in
            
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            do{
                let githubData = try JSONDecoder().decode(Github.self, from: data)
                completion(.success(githubData))
            }
            catch{
                completion(.failure(error))
            }
        }.resume()
    }
}


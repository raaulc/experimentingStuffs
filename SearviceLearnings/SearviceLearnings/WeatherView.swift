//
//  WeatherData.swift
//  SearviceLearnings
//
//  Created by Rahul Rathod on 17/04/2023.
//

import Foundation
import SwiftUI

// Step 3: Weather model
struct Weather: Codable {
    let main: Main
    let weather: [Weat]
    let wind: Wind
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Weat: Codable {
        let description: String
    }
    
    struct Wind: Codable {
        let speed: Double
    }
}

// Step 4: API service
class WeatherService: ObservableObject {
    private let apiKey = "aac632c00547cef4b8c8c942ede6d034"
    
    func fetchWeatherData(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


// Step 5: Weather view
struct WeatherView: View {
    @StateObject private var weatherService = WeatherService()
    @State private var weather: Weather?
    @State private var city = ""
    
    var body: some View {
        VStack {
            TextField("Enter city name", text: $city, onCommit: fetchWeatherData)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let weather = weather {
                Text("\(weather.main.temp)°C")
                Text(weather.weather.first?.description ?? "No description")
                Text("\(weather.wind.speed) m/s")
            } else {
                Text("No weather data")
            }
        }
        .padding()
    }
    
    private func fetchWeatherData() {
        weatherService.fetchWeatherData(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.weather = weather
                case .failure(let error):
                    print("Failed to fetch weather data: \(error)")
                }
            }
        }
    }
}

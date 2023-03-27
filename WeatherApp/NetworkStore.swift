//
//  NetworkStore.swift
//  WeatherApp
//
//  Created by Hasindu Mendis on 2023-02-17.
//

import Foundation

class NetworkStore: ObservableObject {
    
    @Published var weatherData: WeatherDataModel?
    
    private var baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(APIConstants.KEY)&units=metric"
    
    func fetchData(cityName: String) async {
        
        //String URL
        var urlString = "\(baseURL)&q=\(cityName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        //URL
        guard let url = URL(string: urlString) else {
            print("Invalid Url")
            return
        }
        
        //URL Session
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            //Decode
            let decodableDate = try JSONDecoder().decode(WeatherDTO.self, from: data)
            
            DispatchQueue.main.async {
                self.weatherData = WeatherDataModel(name: decodableDate.name,
                                                    description: decodableDate.weather[0].description.capitalized,
                                               temp: decodableDate.main.temp,
                                               pressure: decodableDate.main.pressure,
                                               humidity: decodableDate.main.humidity,
                                               feelsLike: decodableDate.main.feelsLike,
                                               visibility: decodableDate.visibility,
                                               windSpeed: decodableDate.wind.speed,
                                               cloudPrecentage: decodableDate.clouds.all)
            }
            
        } catch {
            print("Error")
        }

        
    }
}

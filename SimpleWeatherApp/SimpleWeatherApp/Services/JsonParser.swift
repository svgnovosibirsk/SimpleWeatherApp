//
//  JsonParser.swift
//  SimpleWeatherApp
//
//  Created by Sergey on 23.12.2023.
//

import Foundation

final class JsonParser {
    func parseWeatherData(from json: [String: Any]) -> WeatherDataModel? {
        let weatherModel = WeatherDataModel()
        
        //TODO: Keys to Constants
        if let response = json["main"] as? [String: Any] {
            if let temp = response["temp"] as? Double {
                weatherModel.temperature = Int(temp - 273.15)
            }
            
            if let name = json["name"] as? String {
                weatherModel.city = name
            }
            
            guard let weather = json["weather"] as? [[String: Any]] else { return nil }
            let first = weather[0]
            guard let id = first["id"] as? Int else { return nil }
            weatherModel.condition = id
            weatherModel.weatherIconName = weatherModel.updateWeatherIcon(condition: weatherModel.condition)
        }
        
        return weatherModel
    }
}

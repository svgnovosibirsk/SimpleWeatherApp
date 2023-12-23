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
    
    func parseWeatherForecast(from json: [String: Any]) -> [String: Double] {
        var forecasts: [String: Double] = [:]
        //TODO: Keys to Constants
        if let forecastList = json["list"] as? [[String: Any]] {
            var i = 10
            
            while i <= 26 {
                var forecast = forecastList[i]
                var day = ""
                
                if let textDate = forecast["dt_txt"] as? String {
                    let start = textDate.index(textDate.startIndex, offsetBy: 8)
                    let end = textDate.index(textDate.startIndex, offsetBy: 11)
                    let range = start..<end
                    let substring = String(textDate[range]).trimmingCharacters(in: .whitespaces)
                    day = substring
                }
                
                if let weather = forecast["main"] as? [String: Any] {
                    if let temperature = weather["temp"] as? Double {
                        forecasts[day] = temperature
                    }
                }
                
                i += 8
            }
        }
        return forecasts
    }
}

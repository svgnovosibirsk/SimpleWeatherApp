//
//  JsonParser.swift
//  SimpleWeatherApp
//
//  Created by Sergey on 23.12.2023.
//

import Foundation

private enum JsonConstants {
    static let keyMain = "main"
    static let keyTemp = "temp"
    static let keyName = "name"
    static let keyWeather = "weather"
    static let keyId = "id"
    static let keyList = "list"
    static let keyDtTxt = "dt_txt"
}

final class JsonParser {
    func parseWeatherData(from json: [String: Any]) -> WeatherDataModel? {
        let weatherModel = WeatherDataModel()
        
        //TODO: Keys to Constants
        if let response = json[JsonConstants.keyMain] as? [String: Any] {
            if let temp = response[JsonConstants.keyTemp] as? Double {
                weatherModel.temperature = Int(temp - 273.15)
            }
            
            if let name = json[JsonConstants.keyName] as? String {
                weatherModel.city = name
            }
            
            guard let weather = json[JsonConstants.keyWeather] as? [[String: Any]] else { return nil }
            let first = weather[0]
            guard let id = first[JsonConstants.keyId] as? Int else { return nil }
            weatherModel.condition = id
            weatherModel.weatherIconName = weatherModel.updateWeatherIcon(condition: weatherModel.condition)
        }
        
        return weatherModel
    }
    
    func parseWeatherForecast(from json: [String: Any]) -> [String: Double] {
        var forecasts: [String: Double] = [:]
        //TODO: Keys to Constants
        if let forecastList = json[JsonConstants.keyList] as? [[String: Any]] {
            var i = 10
            
            while i <= 26 {
                let forecast = forecastList[i]
                var day = ""
                
                if let textDate = forecast[JsonConstants.keyDtTxt] as? String {
                    let start = textDate.index(textDate.startIndex, offsetBy: 8)
                    let end = textDate.index(textDate.startIndex, offsetBy: 11)
                    let range = start..<end
                    let substring = String(textDate[range]).trimmingCharacters(in: .whitespaces)
                    day = substring
                }
                
                if let weather = forecast[JsonConstants.keyMain] as? [String: Any] {
                    if let temperature = weather[JsonConstants.keyTemp] as? Double {
                        forecasts[day] = temperature
                    }
                }
                
                i += 8
            }
        }
        return forecasts
    }
}

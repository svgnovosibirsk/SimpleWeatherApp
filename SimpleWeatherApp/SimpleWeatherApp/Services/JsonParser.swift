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
    
    static let iStart = 10
    static let iEnd = 26
    static let iStep = 8
    
    static let offset_8 = 8
    static let offset_11 = 11
}

final class JsonParser {
    func parseWeatherData(from json: [String: Any]) -> WeatherDataModel? {
        let weatherModel = WeatherDataModel()
        
        //TODO: Keys to Constants
        if let response = json[JsonConstants.keyMain] as? [String: Any] {
            if let temp = response[JsonConstants.keyTemp] as? Double {
                weatherModel.temperature = Int(temp - Constants.celsiusCoefficient)
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
            var i = JsonConstants.iStart
            
            while i <= JsonConstants.iEnd {
                let forecast = forecastList[i]
                var day = ""
                
                if let textDate = forecast[JsonConstants.keyDtTxt] as? String {
                    let start = textDate.index(textDate.startIndex, offsetBy: JsonConstants.offset_8)
                    let end = textDate.index(textDate.startIndex, offsetBy: JsonConstants.offset_11)
                    let range = start..<end
                    let substring = String(textDate[range]).trimmingCharacters(in: .whitespaces)
                    day = substring
                }
                
                if let weather = forecast[JsonConstants.keyMain] as? [String: Any] {
                    if let temperature = weather[JsonConstants.keyTemp] as? Double {
                        forecasts[day] = temperature
                    }
                }
                
                i += JsonConstants.iStep
            }
        }
        return forecasts
    }
}

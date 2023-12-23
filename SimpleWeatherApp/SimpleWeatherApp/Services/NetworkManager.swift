//
//  NetworkManager.swift
//  SimpleWeatherApp
//
//  Created by Sergey on 23.12.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class NetworkManager {
    enum GWError: Error {
        case invalidResponse(URLResponse?)
        case invalidJSON(Error)
    }
    // TODO: Error handling
    func getWeatherData(parameters: [String: String]) -> Observable<[String: Any]> {
        var urlStr = "https://api.openweathermap.org/data/2.5/weather?q=London&appid=\(Constants.appId)"
        
        if let city = parameters["q"] {
            urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(Constants.appId)"
        } else {
            let lat = parameters["lat"]!
            let lon = parameters["lon"]!
            urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.appId)"
        }
        
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.rx.response(request: request)
            .map { result -> Data in
                return result.data
            }
            .map { data in
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    return json! // TODO: Handle !
            }
            .observe(on: MainScheduler.instance)
            .asObservable()
    }
}

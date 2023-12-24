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
    private enum LocalConstants {
        static let baseURL = "https://api.openweathermap.org/data/2.5/"
        static let methodGet = "GET"
    }
    
    enum GWError: Error {
        case invalidResponse(URLResponse?)
        case invalidJSON(Error)
    }
    // TODO: Error handling
    func getWeatherData(parameters: [String: String]) -> Observable<[String: Any]> {
        //TODO: URL and Keys to Constants
        var urlStr = "\(LocalConstants.baseURL)weather?q=London&appid=\(Constants.appId)"
        
        if let city = parameters[Constants.keyQ] {
            urlStr = "\(LocalConstants.baseURL)weather?q=\(city)&appid=\(Constants.appId)"
        } else {
            let lat = parameters[Constants.keyLatitude]!
            let lon = parameters[Constants.keyLongitude]!
            urlStr = "\(LocalConstants.baseURL)weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.appId)"
        }
        
        let url = URL(string: urlStr)! // TODO: Handle !
        var request = URLRequest(url: url)
        request.httpMethod = LocalConstants.methodGet
        
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
    
    // TODO: Error handling
    func getWeatherForcast(parameters: [String: String]) -> Observable<[String: Any]> {
        //TODO: URL and Keys to Constants
        var urlStr = "\(LocalConstants.baseURL)forecast?q=London&appid=\(Constants.appId)"
        
        if let city = parameters[Constants.keyQ] {
            urlStr = "\(LocalConstants.baseURL)forecast?q=\(city)&appid=\(Constants.appId)"
        } else if let lat = parameters[Constants.keyLatitude],
                  let lon = parameters[Constants.keyLongitude] {
            urlStr = "\(LocalConstants.baseURL)forecast?lat=\(lat)&lon=\(lon)&appid=\(Constants.appId)"
        }
        
        let url = URL(string: urlStr)! // TODO: Handle !
        var request = URLRequest(url: url)
        request.httpMethod = LocalConstants.methodGet
        
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

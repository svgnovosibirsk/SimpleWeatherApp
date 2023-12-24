//
//  ViewModel.swift
//  SimpleWeatherApp
//
//  Created by Sergey on 23.12.2023.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class ViewModel: NSObject {
    
    private enum LocalConstants {
        static let keyAppId = "appid"
        static let incorrectData = "Incorrect data"
        
        static let zero = 0
        static let doubleZero = 0.0
        static let daysCount = 3
        
        static let first = 0
        static let second = 1
        static let third = 2
    }
    
    //MARK: Properties
    var searchText = PublishSubject<String?>()
    var cityName = PublishSubject<String>()
    var temperature = PublishSubject<String>()
    var iconImage = PublishSubject<UIImage>()
    var forecastTemperatureFirst = PublishSubject<String>()
    var forecastTemperatureSecond = PublishSubject<String>()
    var forecastTemperatureThird = PublishSubject<String>()
    var forecastDateFirst = PublishSubject<String>()
    var forecastDateSecond = PublishSubject<String>()
    var forecastDateThird = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    let locationManager = CLLocationManager()
    let networkManager = NetworkManager()
    let jsonParser = JsonParser()
    
    //MARK: - Lifecycle
    override init() {
        super.init()
        
        setupLocationManager()
    }
    
    //MARK: - Methods
    func getWeatherButtonDidPress(with cityName: String) {
        let params = [Constants.keyQ: cityName, LocalConstants.keyAppId: Constants.appId]
        
        getWeatherDataFromNetwork(with: params)
        getWeatherForecastFromNetwork(with: params)
    }
    
    private func updateProperties(with dataModel: WeatherDataModel) {
        cityName.onNext(dataModel.city)
        temperature.onNext("\(dataModel.temperature)")
        let iconImageName = dataModel.weatherIconName
        if let image = UIImage(named: iconImageName) {
            iconImage.onNext(image)
        }
    }
    
    private func updateForecastProperties(with dict: [String: Double]) {
        guard dict.count == LocalConstants.daysCount else {
            cityName.onNext(LocalConstants.incorrectData)
            return
        }
        
        let sortedForecasts = dict.sorted{ Int($0.key) ?? LocalConstants.zero < Int($1.key) ?? LocalConstants.zero }
        
        forecastDateFirst.onNext("\(sortedForecasts[LocalConstants.first].key)")
        forecastDateSecond.onNext("\(sortedForecasts[LocalConstants.second].key)")
        forecastDateThird.onNext("\(sortedForecasts[LocalConstants.third].key)")
        
        forecastTemperatureFirst.onNext("\(Int(sortedForecasts[LocalConstants.first].value - Constants.celsiusCoefficient))")
        forecastTemperatureSecond.onNext("\(Int(sortedForecasts[LocalConstants.second].value - Constants.celsiusCoefficient))")
        forecastTemperatureThird.onNext("\(Int(sortedForecasts[LocalConstants.third].value - Constants.celsiusCoefficient))")
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func getWeatherDataFromNetwork(with params: [String: String]) {
        guard let weatherData = networkManager.getWeatherData(parameters: params) else { return }
        weatherData
            .subscribe(onNext: { [weak self] json in
                if let weatherModel = self?.jsonParser.parseWeatherData(from: json) {
                    self?.updateProperties(with: weatherModel)
                }
            }, onError: { [weak self] error in
                self?.cityName.onNext(LocalConstants.incorrectData)
            }).disposed(by: disposeBag)
    }
    
    private func getWeatherForecastFromNetwork(with params: [String: String]) {
        guard let weatherForcast = networkManager.getWeatherForcast(parameters: params) else { return }
        weatherForcast
            .subscribe(onNext: { [weak self] json in
                if let forecast = self?.jsonParser.parseWeatherForecast(from: json) {
                    self?.updateForecastProperties(with: forecast)
                }
            }, onError: {[weak self] error in
                self?.cityName.onNext(LocalConstants.incorrectData)
            }).disposed(by: disposeBag)
    }
}

extension ViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if location.horizontalAccuracy > LocalConstants.doubleZero {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String: String] = [Constants.keyLatitude: latitude,
                                            Constants.keyLongitude: longitude,
                                            LocalConstants.keyAppId: Constants.appId]
           
            getWeatherDataFromNetwork(with: params)
            getWeatherForecastFromNetwork(with: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        cityName.onNext(Constants.locationUnavailable)
    }
}

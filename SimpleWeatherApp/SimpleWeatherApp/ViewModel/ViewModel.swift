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
        static let celsiusCoefficient = 273.15
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
        //TODO: Keys to Constants
        let params = [Constants.keyQ: cityName, LocalConstants.keyAppId: Constants.appId]
        
        //TODO: To make weather and forcast requests via Dispatch group and update UI when they both a finished
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
        guard dict.count == 3 else {
            cityName.onNext(LocalConstants.incorrectData)
            return
        }
        
        let sortedForecasts = dict.sorted{ Int($0.key) ?? 0 < Int($1.key) ?? 0 }
        
        forecastDateFirst.onNext("\(sortedForecasts[0].key)")
        forecastDateSecond.onNext("\(sortedForecasts[1].key)")
        forecastDateThird.onNext("\(sortedForecasts[2].key)")
        
        forecastTemperatureFirst.onNext("\(Int(sortedForecasts[0].value - LocalConstants.celsiusCoefficient))")
        forecastTemperatureSecond.onNext("\(Int(sortedForecasts[1].value - LocalConstants.celsiusCoefficient))")
        forecastTemperatureThird.onNext("\(Int(sortedForecasts[2].value - LocalConstants.celsiusCoefficient))")
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //TODO: To make weather and forcast requests via Dispatch group and update UI when they both a finished
    private func getWeatherDataFromNetwork(with params: [String: String]) {
        networkManager.getWeatherData(parameters: params)
            .subscribe(onNext: { [weak self] json in
                if let weatherModel = self?.jsonParser.parseWeatherData(from: json) {
                    self?.updateProperties(with: weatherModel)
                }
            }).disposed(by: disposeBag)
    }
    
    private func getWeatherForecastFromNetwork(with params: [String: String]) {
        networkManager.getWeatherForcast(parameters: params)
            .subscribe(onNext: { [weak self] json in
                if let forecast = self?.jsonParser.parseWeatherForecast(from: json) {
                    self?.updateForecastProperties(with: forecast)
                }
            }).disposed(by: disposeBag)
    }
}

extension ViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            //TODO: Keys to Constants
            let params: [String: String] = [Constants.keyLatitude: latitude,
                                            Constants.keyLongitude: longitude,
                                            LocalConstants.keyAppId: Constants.appId]
           
            //TODO: join in dispatch group
            getWeatherDataFromNetwork(with: params)
            getWeatherForecastFromNetwork(with: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        cityName.onNext(Constants.locationUnavailable)
    }
}

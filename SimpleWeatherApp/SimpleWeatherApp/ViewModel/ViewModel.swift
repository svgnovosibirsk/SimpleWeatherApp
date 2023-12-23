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
    
    //MARK: Properties
    var searchText = PublishSubject<String?>()
    var cityName = PublishSubject<String>()
    var temperature = PublishSubject<String>()
    var iconImage = PublishSubject<UIImage>()
    var forecastFirst = PublishSubject<String>()
    var forecastSecond = PublishSubject<String>()
    var forecastThird = PublishSubject<String>()
    
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
        let params = ["q": cityName, "appid": Constants.appId]
        getWeatherDataFromNetwork(with: params)
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
        for (key, val) in dict {
            print("\(key): \(val)")
        }
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
            let params: [String: String] = ["lat": latitude,
                                            "lon": longitude,
                                            "appid": Constants.appId]
           
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

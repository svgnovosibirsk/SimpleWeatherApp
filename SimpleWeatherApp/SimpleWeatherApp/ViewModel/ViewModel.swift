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
    
    let weatherDataModel = WeatherDataModel() // make as parametr in methods
    
    //MARK: - Lifecycle
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //updatePropertiesWithWeatherData()
    }
    
    //MARK: - Methods
    func getWeatherButtonDidPress() {
        print(#function)
//        cityName.onNext("Gothem city") // TEST
//        iconImage.onNext(UIImage(named: "snow5")!) // TEST
//        temperature.onNext("-12") // TEST
//        forecastFirst.onNext("-11") // TEST
//        forecastSecond.onNext("-10") // TEST
//        forecastThird.onNext("-12") // TEST
    }
    
    func updateProperties(with dataModel: WeatherDataModel) {
        cityName.onNext(dataModel.city)
        temperature.onNext("\(dataModel.temperature)")
        let iconImageName = dataModel.weatherIconName
        if let image = UIImage(named: iconImageName) {
            iconImage.onNext(image)
        }
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
            
            let params: [String: String] = ["lat": latitude,
                                            "lon": longitude,
                                            "appid": Constants.appId]
           
            networkManager.getWeatherData(parameters: params)
                .subscribe(onNext: { [weak self] json in
                    //print(json)
                    //self?.updatePropertiesWithWeatherData(json: json )
                    if let weatherModel = self?.jsonParser.parseWeatherData(from: json) {
                        self?.updateProperties(with: weatherModel)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        cityName.onNext(Constants.locationUnavailable)
    }
}

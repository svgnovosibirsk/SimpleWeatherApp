//
//  ViewModel.swift
//  SimpleWeatherApp
//
//  Created by Sergey on 23.12.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class ViewModel {
    
    //MARK: Properties
    var searchText = PublishSubject<String?>()
    var cityName = PublishSubject<String>()
    var temperature = PublishSubject<String>()
    var iconImage = PublishSubject<UIImage>()
    var forecastFirst = PublishSubject<String>()
    var forecastSecond = PublishSubject<String>()
    var forecastThird = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    
}

//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Sergey on 23.12.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    //MARK: Properties
    let selectCityTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: Constants.fontSize_20)
        textField.placeholder = Constants.cityNamePlaceholder.capitalized
        textField.layer.borderWidth = Constants.borderWidth_2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = Constants.cornerRadius_5
        return textField
    }()
    
    let getWeatherButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitleColor(.systemCyan, for: .normal)
        button.setTitle(Constants.buttonTitle.uppercased(), for: .normal)
        button.addTarget(self, action: #selector(getWeatherButtonDidPress), for: .touchUpInside)
        button.layer.cornerRadius = Constants.cornerRadius_5
        return button
    }()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_20)
        label.text = "Karaganda"
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_40)
        label.text = "+21"
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Constants.iconSunny))
        return imageView
    }()

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        
        setupScreen()
    }
    
    @objc func getWeatherButtonDidPress() {
        print(#function)
    }
}

//MARK: Setup UI
private extension ViewController {
    func setupScreen() {
        setupSelectCityTextField()
        setupGetWeatherButton()
        setupCityNameLabel()
        setupTemperatureLabel()
        setupIconImageView()
    }
    
    func setupSelectCityTextField() {
        view.addSubview(selectCityTextField)
        selectCityTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.constant_100)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.constant_200)
            make.height.equalTo(Constants.constant_50)
        }
    }
    
    func setupGetWeatherButton() {
        view.addSubview(getWeatherButton)
        getWeatherButton.snp.makeConstraints { make in
            make.top.equalTo(selectCityTextField.snp.bottom).offset(Constants.constant_20)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.constant_200)
            make.height.equalTo(Constants.constant_50)
        }
    }
    
    func setupCityNameLabel() {
        view.addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(getWeatherButton.snp.bottom).offset(Constants.constant_20)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupTemperatureLabel() {
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(Constants.constant_20)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupIconImageView() {
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(Constants.constant_20)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.constant_100)
            make.height.equalTo(Constants.constant_100)
        }
    }
    
}

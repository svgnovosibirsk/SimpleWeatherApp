//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Sergey on 23.12.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    //MARK: Properties
    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
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
        label.text = Constants.emptyString
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_40)
        label.text = Constants.emptyString
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Constants.iconSunny))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let forcastDateStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    let forcastTemperatureStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    let forecastTemperatureLabelFirst: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_30)
        label.text = Constants.emptyString
        label.textAlignment = .center
        label.layer.borderWidth = Constants.borderWidth_2
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = Constants.cornerRadius_5
        return label
    }()
    
    let forecastTemperatureLabelSecond: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_30)
        label.text = Constants.emptyString
        label.textAlignment = .center
        label.layer.borderWidth = Constants.borderWidth_2
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = Constants.cornerRadius_5
        return label
    }()
    
    let forecastTemperatureLabelThird: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_30)
        label.text = Constants.emptyString
        label.textAlignment = .center
        label.layer.borderWidth = Constants.borderWidth_2
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = Constants.cornerRadius_5
        return label
    }()
    
    let forecastDateLabelFirst: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_20)
        label.text = Constants.emptyString
        label.textAlignment = .center
        return label
    }()
    
    let forecastDateLabelSecond: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_20)
        label.text = Constants.emptyString
        label.textAlignment = .center
        return label
    }()
    
    let forecastDateLabelThird: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_20)
        label.text = Constants.emptyString
        label.textAlignment = .center
        return label
    }()

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        
        setupScreen()
        bindToViewModel()
        setupDismissKeyboardGestureRecognizer()
    }
    
    //MARK: - Flow
    @objc func getWeatherButtonDidPress() {
        let cityName = selectCityTextField.text!
        viewModel.getWeatherButtonDidPress(with: cityName)
    }
    
    private func bindToViewModel() {
        viewModel.cityName.bind(to: cityNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.temperature.bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.iconImage.bind(to: iconImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.forecastTemperatureFirst.bind(to: forecastTemperatureLabelFirst.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.forecastTemperatureSecond.bind(to: forecastTemperatureLabelSecond.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.forecastTemperatureThird.bind(to: forecastTemperatureLabelThird.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.forecastDateFirst.bind(to: forecastDateLabelFirst.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.forecastDateSecond.bind(to: forecastDateLabelSecond.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.forecastDateThird.bind(to: forecastDateLabelThird.rx.text)
            .disposed(by: disposeBag)
    }
    
    //TODO: Implement Keyboard handling
}

//MARK: Setup UI
private extension ViewController {
    func setupScreen() {
        setupSelectCityTextField()
        setupGetWeatherButton()
        setupCityNameLabel()
        setupTemperatureLabel()
        setupIconImageView()
        setupForcastDateStackView()
        setForcastStackView()
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
    
    func setupForcastDateStackView() {
        view.addSubview(forcastDateStackView)
        forcastDateStackView.addArrangedSubview(forecastDateLabelFirst)
        forcastDateStackView.addArrangedSubview(forecastDateLabelSecond)
        forcastDateStackView.addArrangedSubview(forecastDateLabelThird)
        
        forcastDateStackView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(Constants.constant_20)
            make.leading.equalToSuperview().offset(Constants.constant_20)
            make.trailing.equalToSuperview().offset(-Constants.constant_20)
            make.height.equalTo(Constants.constant_50)
        }
    }
    
    func setForcastStackView() {
        view.addSubview(forcastTemperatureStackView)
        forcastTemperatureStackView.addArrangedSubview(forecastTemperatureLabelFirst)
        forcastTemperatureStackView.addArrangedSubview(forecastTemperatureLabelSecond)
        forcastTemperatureStackView.addArrangedSubview(forecastTemperatureLabelThird)
        
        forcastTemperatureStackView.snp.makeConstraints { make in
            make.top.equalTo(forcastDateStackView.snp.bottom)
            make.leading.equalToSuperview().offset(Constants.constant_20)
            make.trailing.equalToSuperview().offset(-Constants.constant_20)
            make.height.equalTo(Constants.constant_80)
        }
    }
    
    //MARK: - Keyboard handling
    private func setupDismissKeyboardGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

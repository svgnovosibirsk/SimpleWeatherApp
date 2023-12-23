//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Sergey on 23.12.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let selectCityTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: Constants.fontSize_20)
        textField.placeholder = Constants.cityNamePlaceholder
        textField.layer.borderWidth = Constants.borderWidth_2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = Constants.cornerRadius_5
        return textField
    }()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_20)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        
        setupScreen()
    }
}

private extension ViewController {
    func setupScreen() {
        setupSelectCityTextField()
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
    
}

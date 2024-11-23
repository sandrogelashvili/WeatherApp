//
//  TempStackView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 23.11.24.
//

import UIKit

class TempStackView: UIView {
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: 36, weight: .light)
        return label
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: 78, weight: .thin)
        return label
    }()
    
    private var skyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private var maxTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private var minTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private var tempStackView: UIStackView = {
        let stackView = GlassmorphicStackView(
            axis: .vertical,
            spacing: 8,
            alignment: .center,
            cornerRadius: 16
        )
        return stackView
    }()
    
    private var maxAndMinTempStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    
    private func setUpUI() {
        addTempStackView()
        addMaxAndMinTempStackView()
    }
    
    private func addTempStackView() {
        tempStackView.addArrangedSubview(cityLabel)
        tempStackView.addArrangedSubview(tempLabel)
        tempStackView.addArrangedSubview(skyLabel)
        tempStackView.addArrangedSubview(maxAndMinTempStackView)
        addSubview(tempStackView)
        tempStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addMaxAndMinTempStackView() {
        maxAndMinTempStackView.addArrangedSubview(maxTempLabel)
        maxAndMinTempStackView.addArrangedSubview(minTempLabel)
    }
    
    func updateTemp(city: String, temperature: String, sky: String, maxTemp: String, minTemp: String) {
        cityLabel.text = city
        tempLabel.text = temperature
        skyLabel.text = sky
        maxTempLabel.text = maxTemp
        minTempLabel.text = minTemp
    }
}

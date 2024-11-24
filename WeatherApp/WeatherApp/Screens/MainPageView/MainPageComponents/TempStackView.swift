//
//  TempStackView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 23.11.24.
//

import UIKit

final class TempStackView: UIView {
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.headline1, weight: .light)
        return label
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.hugeTitle, weight: .thin)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.headline2, weight: .light)
        return label
    }()
    
    private var maxTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.subtitle, weight: .light)
        return label
    }()
    
    private var minTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.subtitle, weight: .light)
        return label
    }()
    
    private var tempStackView: UIStackView = {
        let stackView = GlassmorphicStackView(
            axis: .vertical,
            spacing: Space.xs,
            alignment: .center,
            cornerRadius: CornerRadius.xl2
        )
        return stackView
    }()
    
    private var maxAndMinTempStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Space.s
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
        tempStackView.addArrangedSubview(descriptionLabel)
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
    
    func updateTemp(city: String, temperature: String, description: String, maxTemp: String, minTemp: String) {
        cityLabel.text = city
        tempLabel.text = temperature
        descriptionLabel.text = description
        maxTempLabel.text = maxTemp
        minTempLabel.text = minTemp
    }
}

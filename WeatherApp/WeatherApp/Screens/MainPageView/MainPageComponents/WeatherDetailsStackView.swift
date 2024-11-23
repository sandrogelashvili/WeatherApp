//
//  WeatherDetailsStackView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 23.11.24.
//

import UIKit

class WeatherDetailsStackView: UIView {
    
    private var humidityImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "HumidityIcon"))
        image.contentMode = .scaleAspectFill
        image.tintColor = .white
        return image
    }()
    
    private var humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private var cloudImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "CloudIcon"))
        image.contentMode = .scaleAspectFill
        image.tintColor = .white
        return image
    }()
    
    private var cloudLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private var windSpeedImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "WindIcon"))
        image.contentMode = .scaleAspectFill
        image.tintColor = .white
        return image
    }()
    
    private var windSpeedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private var detailsStackView: UIStackView = {
        let stackView = GlassmorphicStackView(
            axis: .horizontal,
            spacing: 50,
            alignment: .center,
            cornerRadius: 16
        )
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var humidityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private var cloudStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .center
        return stackView
    }()
    
    private var windSpeedStackView: UIStackView = {
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
        addHumidityStackView()
        addCloudStackView()
        addWindSpeedStackView()
        addDetailsStackView()
    }
    
    private func addDetailsStackView() {
        detailsStackView.addArrangedSubview(humidityStackView)
        detailsStackView.addArrangedSubview(cloudStackView)
        detailsStackView.addArrangedSubview(windSpeedStackView)
        addSubview(detailsStackView)
        detailsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addHumidityStackView() {
        humidityStackView.addArrangedSubview(humidityImage)
        humidityStackView.addArrangedSubview(humidityLabel)
        humidityImage.snp.makeConstraints { make in
                make.width.height.equalTo(12)
            }
    }
    
    private func addCloudStackView() {
        cloudStackView.addArrangedSubview(cloudImage)
        cloudStackView.addArrangedSubview(cloudLabel)
        cloudImage.snp.makeConstraints { make in
                make.width.height.equalTo(16)
            }
    }
    
    private func addWindSpeedStackView() {
        windSpeedStackView.addArrangedSubview(windSpeedImage)
        windSpeedStackView.addArrangedSubview(windSpeedLabel)
        windSpeedImage.snp.makeConstraints { make in
                make.width.height.equalTo(16)
            }
    }

    func updateDetails(humidity: String, windSpeed: String, cloud: String) {
        humidityLabel.text = humidity
        windSpeedLabel.text = windSpeed
        cloudLabel.text = cloud
    }
}

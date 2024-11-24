//
//  WeatherDetailsStackView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 23.11.24.
//

import UIKit

final class WeatherDetailsStackView: UIView {
    
    private var humidityImage: UIImageView = {
        let image = UIImageView(image: UIImage.humidityImage)
        image.contentMode = .scaleAspectFill
        image.tintColor = .white
        return image
    }()
    
    private var humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.subtitle, weight: .light)
        return label
    }()
    
    private var cloudImage: UIImageView = {
        let image = UIImageView(image: UIImage.cloudImage)
        image.contentMode = .scaleAspectFill
        image.tintColor = .white
        return image
    }()
    
    private var cloudLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.subtitle, weight: .light)
        return label
    }()
    
    private var windSpeedImage: UIImageView = {
        let image = UIImageView(image: UIImage.windImage)
        image.contentMode = .scaleAspectFill
        image.tintColor = .white
        return image
    }()
    
    private var windSpeedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.subtitle, weight: .light)
        return label
    }()
    
    private var detailsStackView: UIStackView = {
        let stackView = GlassmorphicStackView(
            axis: .horizontal,
            spacing: Space.xl5,
            alignment: .center,
            cornerRadius: CornerRadius.xl2
        )
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var humidityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Space.s
        stackView.alignment = .center
        return stackView
    }()
    
    private var cloudStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Space.m
        stackView.alignment = .center
        return stackView
    }()
    
    private var windSpeedStackView: UIStackView = {
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
            make.width.height.equalTo(Size.s.width)
            }
    }
    
    private func addCloudStackView() {
        cloudStackView.addArrangedSubview(cloudImage)
        cloudStackView.addArrangedSubview(cloudLabel)
        cloudImage.snp.makeConstraints { make in
            make.width.height.equalTo(Size.m.width)
            }
    }
    
    private func addWindSpeedStackView() {
        windSpeedStackView.addArrangedSubview(windSpeedImage)
        windSpeedStackView.addArrangedSubview(windSpeedLabel)
        windSpeedImage.snp.makeConstraints { make in
            make.width.height.equalTo(Size.m.width)
            }
    }

    func updateDetails(humidity: String, windSpeed: String, cloud: String) {
        humidityLabel.text = humidity
        windSpeedLabel.text = windSpeed
        cloudLabel.text = cloud
    }
}

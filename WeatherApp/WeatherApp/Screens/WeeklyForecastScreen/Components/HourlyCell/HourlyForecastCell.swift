//
//  HourlyForecastCell.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 24.11.24.
//

import UIKit

final class HourlyForecastCell: UICollectionViewCell {
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.subtitle, weight: .light)
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.subtitle, weight: .light)
        return label
    }()

    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .neutralWhite
        return imageView
    }()
    
    private var hourlyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.s
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.requiredError)
    }
    
    private func setUpUI() {
        hourlyStackView.addArrangedSubview(tempLabel)
        hourlyStackView.addArrangedSubview(iconImageView)
        hourlyStackView.addArrangedSubview(timeLabel)
        
        contentView.addSubview(hourlyStackView)
        hourlyStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Size.xl5.width)
        }
    }
    
    func configure(temperature: String, iconUrl: URL, time: String) {
            tempLabel.text = temperature
            timeLabel.text = time
            loadImage(from: iconUrl)
        }
    
    private func loadImage(from url: URL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self else { return }
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.iconImageView.image = image
                    }
                }
            }.resume()
        }
}

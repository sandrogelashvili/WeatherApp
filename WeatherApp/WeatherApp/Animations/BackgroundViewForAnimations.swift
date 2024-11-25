//
//  BackgroundViewForAnimations.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 25.11.24.
//

import UIKit
import SnapKit

final class DynamicBackgroundView: UIView {

    private let backgroundImageView = UIImageView()
    private let gradientLayer = CAGradientLayer()

    init(frame: CGRect, weatherIcon: String) {
        super.init(frame: frame)
        setUpBackground(for: weatherIcon)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradient layer frame when the view's bounds change
        gradientLayer.frame = bounds
    }

    private func setUpBackground(for weatherIcon: String) {
        // Set up gradient layer
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)

        // Set up image view using SnapKit for layout
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.leading.equalToSuperview()
            make.width.height.equalTo(200)
        }

        // Set background and animation based on weather icon
        configureBackground(for: weatherIcon)
    }

    private func configureBackground(for weatherIcon: String) {
        switch weatherIcon {
        case "01d": // Sun
            backgroundImageView.image = UIImage(named: "Sun02")  // Load sun image from assets
            gradientLayer.colors = [UIColor.dayColorDark.cgColor, UIColor.dayColorLight.cgColor]
        case "01n": // Moon
            backgroundImageView.image = UIImage(named: "MoonFull01")  // Load moon image from assets
            gradientLayer.colors = [UIColor.nightColorDark.cgColor, UIColor.nightColorLight.cgColor]
        default: // Any other weather
            backgroundImageView.image = nil
            gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        }
    }

    // Update the background dynamically if weather icon changes
    func updateBackground(for weatherIcon: String) {
        configureBackground(for: weatherIcon)
    }
}

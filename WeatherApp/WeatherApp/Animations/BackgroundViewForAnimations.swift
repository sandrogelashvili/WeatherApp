//
//  BackgroundViewForAnimations.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 25.11.24.
//

import UIKit
import SnapKit
import Lottie

final class DynamicBackgroundView: UIView {
    
    private let backgroundImageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private var animationViews: [LottieAnimationView] = []
    
    private let weatherAnimationMapping: [String: [(name: String, layout: AnimationLayout)]] = [
        // clear sky
        "01d": [("LottieBirds", .birds)],
        "01n": [("LottieStars", .stars)],
        // few clouds
        "02d": [("FullCloudsLight", .clouds)],
        "02n": [("FullCloudsLight", .clouds)],
        // scattered clouds
        "03d": [("FullCloudsLight", .clouds)],
        "03n": [("FullCloudsLight", .clouds)],
        // broken clouds
        "04d": [("FullCloudsDark", .clouds)],
        "04n": [("FullCloudsDark", .clouds)],
        // shower rain
        "09d": [("FullCloudsDark", .clouds), ("LottieRain", .rain)],
        "09n": [("FullCloudsDark", .clouds), ("LottieRain", .rain)],
        // rain
        "10d": [("FullCloudsLight", .clouds), ("LottieRain", .rain)],
        "10n": [("FullCloudsLight", .clouds), ("LottieRain", .rain)],
        // thunderstorm
        "11d": [("FullCloudsDark", .clouds), ("LottieRain", .rain), ("LottieThunder", .thunder)],
        "11n": [("FullCloudsDark", .clouds), ("LottieRain", .rain), ("LottieThunder", .thunder)],
        // snow
        "13d": [("LottieSnow", .snow), ("LottieClouds", .clouds)],
        "13n": [("LottieSnow", .snow), ("LottieClouds", .clouds)],
        // mist
        "50d": [("LottieClouds", .clouds)],
        "50n": [("LottieClouds", .clouds)]
    ]
    
    enum AnimationLayout {
        case birds, rain, clouds, snow, stars, thunder
    }
    
    init(frame: CGRect, weatherIcon: String) {
        super.init(frame: frame)
        setUpBackground(for: weatherIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setUpBackground(for weatherIcon: String) {
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.equalToSuperview()
            make.width.height.equalTo(200)
        }
        configureBackground(for: weatherIcon)
    }
    
    private func configureBackground(for weatherIcon: String) {
        let animations = weatherAnimationMapping[weatherIcon] ?? []
        
        let dayCloudyColors = [UIColor.dayCloudyColorDark.cgColor, UIColor.dayCloudyColorLight.cgColor]
        let nightCloudyColors = [UIColor.nightCloudyColorDark.cgColor, UIColor.nightCloudyColorLight.cgColor]
        let dayColors = [UIColor.dayColorDark.cgColor, UIColor.dayColorLight.cgColor]
        let nightColors = [UIColor.nightColorDark.cgColor, UIColor.nightColorLight.cgColor]
        let daySnowyColors = [UIColor.daySnowyColorDark.cgColor, UIColor.daySnowyColorLight.cgColor]
        
        switch weatherIcon {
        case "01d", "02d", "10d":
            backgroundImageView.image = UIImage(named: "Sun02")
            gradientLayer.colors = dayColors
        case "01n", "02n", "10n":
            backgroundImageView.image = UIImage(named: "MoonFull01")
            gradientLayer.colors = nightColors
        case "03d", "04d", "09d", "11d", "50d":
            backgroundImageView.image = nil
            gradientLayer.colors = dayCloudyColors
        case "03n", "04n", "09n", "11n", "50n":
            backgroundImageView.image = nil
            gradientLayer.colors = nightCloudyColors
        case "13d":
            backgroundImageView.image = nil
            gradientLayer.colors = daySnowyColors
        case "13n":
            backgroundImageView.image = nil
            gradientLayer.colors = nightColors
        default:
            backgroundImageView.image = nil
            gradientLayer.colors = [UIColor.neutralWhite.cgColor, UIColor.neutralBlack.cgColor]
        }
        
        setupLottieAnimations(animations: animations)
    }
    
    private func setupLottieAnimations(animations: [(name: String, layout: AnimationLayout)]) {
        animationViews.forEach { $0.removeFromSuperview() }
        animationViews.removeAll()
        
        for animation in animations {
            let animationView = LottieAnimationView(name: animation.name)
            animationView.contentMode = .scaleAspectFill
            animationView.loopMode = .loop
            
            switch animation.layout {
            case .birds:
                animationView.frame = CGRect(x: 0, y: 100, width: bounds.width, height: bounds.height * 0.10)
            case .rain:
                animationView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            case .clouds:
                animationView.frame = CGRect(x: 0, y: 100, width: bounds.width, height: bounds.height * 0.25)
            case .snow:
                animationView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            case .stars:
                animationView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            case .thunder:
                animationView.frame = CGRect(x: 100, y: 0, width: bounds.width, height: bounds.height * 0.75)
            }
            addSubview(animationView)
            animationViews.append(animationView)
            animationView.play()
        }
    }
    
    func updateBackground(for weatherIcon: String) {
        configureBackground(for: weatherIcon)
    }
}


//
//  MainPageView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 22.11.24.
//

import UIKit
import Alamofire

private enum Constants {
    static let pointX: CGFloat = 0.5
    static let endPointY: CGFloat = 1.0
    static let alphaComponent: CGFloat = 0.3
    static let customImageSize: CGFloat = 200
}

final class MainPageView: UIViewController {
    
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = String.searchFieldPlaceHolder
        return searchController
    }()
    
    private var sunImage: UIImageView = {
        let image = UIImageView(image: UIImage.sunImage)
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private var tempStackView: TempStackView = {
        let stackView = TempStackView()
        return stackView
    }()
    
    private var weatherDetailsStackView: WeatherDetailsStackView = {
        let stackView = WeatherDetailsStackView()
        return stackView
    }()
    
    private var hourlyForecastView: HourlyForecastView = {
        let hourlyView = HourlyForecastView()
        return hourlyView
    }()
    
    let exampleForecasts = [
                ("15°", "sun", "15:00"),
                ("16°", "sun", "16:00"),
                ("14°", "sun", "17:00"),
                ("12°", "sun", "18:00"),
                ("14°", "sun", "11:00"),
                ("15°", "sun", "12:00"),
                ("16°", "sun", "13:00"),
                ("17°", "sun", "14:00"),
                ("18°", "sun", "15:00"),
                ("19°", "sun", "16:00"),
                ("11°", "sun", "17:00"),
            ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        navigationItem.hidesBackButton = true
        setGradientBackground()
        customizeSearchBarAppearance()
        setUpUI()
        fetchWeatherData()
    }
    
    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(#colorLiteral(red: 0.1271144748, green: 0.3459367156, blue: 0.5822487473, alpha: 1)).cgColor,
            UIColor(#colorLiteral(red: 0.5082734227, green: 0.6511721015, blue: 0.8018501401, alpha: 1)).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: Constants.pointX, y: .zero)
        gradientLayer.endPoint = CGPoint(x: Constants.pointX, y: Constants.endPointY)
        view.layer.insertSublayer(gradientLayer, at: .zero)
    }
    
    private func customizeSearchBarAppearance() {
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.searchTextField.textColor = UIColor.white
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: String.searchFieldPlaceHolder,
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        if let textField = searchController.searchBar.value(forKey: String.searchBarKey) as? UITextField {
            textField.backgroundColor = UIColor.white.withAlphaComponent(Constants.alphaComponent)
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = textField.bounds
            textField.addSubview(blurView)
            textField.sendSubviewToBack(blurView)
        }
    }
    
    private func setUpUI() {
        addImage()
        addTempStackView()
        addWeatherDetailsStackView()
        addHourlyForecastStackView()
    }
    
    private func addImage() {
        view.addSubview(sunImage)
        sunImage.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.s)
            make.top.equalTo(view.snp.top).offset(Space.s)
            make.width.height.equalTo(Constants.customImageSize)
        }
    }
    
    private func addTempStackView() {
        view.addSubview(tempStackView)
        tempStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(sunImage.snp.bottom).offset(Space.xl3)
        }
    }
    
    private func addWeatherDetailsStackView() {
        view.addSubview(weatherDetailsStackView)
        weatherDetailsStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(tempStackView.snp.bottom).offset(Space.xl3)
        }
    }
    
    private func addHourlyForecastStackView() {
        view.addSubview(hourlyForecastView)
        hourlyForecastView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(weatherDetailsStackView.snp.bottom).offset(Space.xl3)
        }
    }
    
    private func fetchWeatherData() {
        tempStackView.updateTemp(
            city: "Tbilisi",
            temperature: "18°",
            sky: "Clear",
            maxTemp: "Max: 20°",
            minTemp: "Min: 15°"
        )
        
        weatherDetailsStackView.updateDetails(
            humidity: "67%",
            windSpeed: "5 km/h",
            cloud: "0%"
        )
        
        hourlyForecastView.updateHourly(date: "November 23", forecasts: exampleForecasts)
    }
}

extension MainPageView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return
        }
        print("Searching for: \(searchText)")
    }
}

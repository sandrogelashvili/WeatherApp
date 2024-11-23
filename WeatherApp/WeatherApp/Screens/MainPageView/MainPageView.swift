//
//  MainPageView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 22.11.24.
//

import UIKit
import Alamofire

class MainPageView: UIViewController {
    
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a city"
        return searchController
    }()
    
    private var sunImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "sun"))
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
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func customizeSearchBarAppearance() {
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.searchTextField.textColor = UIColor.white
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search for a city",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
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
    }
    
    private func addImage() {
        view.addSubview(sunImage)
        sunImage.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(12)
            make.top.equalTo(view.snp.top).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(sunImage.snp.width)
        }
    }
    
    private func addTempStackView() {
        view.addSubview(tempStackView)
        tempStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.top.equalTo(sunImage.snp.bottom).offset(30)
        }
    }
    
    private func addWeatherDetailsStackView() {
        view.addSubview(weatherDetailsStackView)
        weatherDetailsStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.top.equalTo(tempStackView.snp.bottom).offset(30)
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

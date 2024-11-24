//
//  MainPageView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 22.11.24.
//

import UIKit

private enum Constants {
    static let pointX: CGFloat = 0.5
    static let endPointY: CGFloat = 1.0
    static let alphaComponent: CGFloat = 0.3
    static let customImageSize: CGFloat = 200
}

final class MainPageView: UIViewController {
    private var mainPageViewModel = MainPageViewModel()
    
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
    
    private var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
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
        navigationItem.hidesBackButton = true
        setGradientBackground()
        customizeSearchBarAppearance()
        setUpUI()
        fetchWeatherData()
        setupViewModelBindings()
        searchController.searchBar.delegate = self
        addActionLocationButton()
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
        addLocationButton()
        addTempStackView()
        addWeatherDetailsStackView()
        addHourlyForecastStackView()
        
    }
    
    private func addLocationButton() {
        view.addSubview(locationButton)
        locationButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.s)
            make.top.equalTo(view.snp.top).offset(175)
            make.width.height.equalTo(40)
        }
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
        hourlyForecastView.updateHourly(
            date: "November 23",
            forecasts: exampleForecasts
        )
    }
    
    private func setupViewModelBindings() {
        mainPageViewModel.onWeatherDataUpdated = { [weak self] in
            self?.updateUI()
        }
        mainPageViewModel.onError = { [weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func updateUI() {
        tempStackView.updateTemp(
            city: mainPageViewModel.city,
            temperature: mainPageViewModel.getWeatherData(forKey: .temperature),
            description: mainPageViewModel.getWeatherData(forKey: .weatherDescription),
            maxTemp: mainPageViewModel.getWeatherData(forKey: .maxTemp),
            minTemp: mainPageViewModel.getWeatherData(forKey: .minTemp)
        )
        
        weatherDetailsStackView.updateDetails(
            humidity: mainPageViewModel.getWeatherData(forKey: .humidity),
            windSpeed: mainPageViewModel.getWeatherData(forKey: .maxTemp),
            cloud: mainPageViewModel.getWeatherData(forKey: .clouds)
        )
    }
    
    private func addActionLocationButton() {
        locationButton.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
    }
    
    @objc private func locationButtonPressed() {
        if let currentLocation = mainPageViewModel.currentLocation {
            mainPageViewModel.fetchWeatherByCoordinates(
                latitude: currentLocation.coordinate.latitude,
                longitude: currentLocation.coordinate.longitude
            )
        } else {
            mainPageViewModel.onError = { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            mainPageViewModel.requestLocation()
        }
    }
}

extension MainPageView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        mainPageViewModel.updateCity(newCity: searchText)
    }
}

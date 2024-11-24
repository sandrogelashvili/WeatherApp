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
    static let customSizeButtonStack: CGFloat = 160
}

final class MainPageView: UIViewController {
    private var mainPageViewModel = MainPageViewModel()
    
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = String.searchFieldPlaceHolder
        return searchController
    }()
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor.clear
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.locationButtonIcon, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private var weeklyForecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.weeklyButtonString, for: .normal)
        button.setImage(UIImage.leftArrowButtonIcon, for: .normal)
        button.tintColor = .nightColorDark
        button.backgroundColor = .white
        button.layer.cornerRadius = CornerRadius.m
        button.semanticContentAttribute = .forceRightToLeft
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: Space.xs)
        button.configuration = configuration
        return button
    }()
    
    private var tempStackView: TempStackView = {
        let stackView = TempStackView()
        return stackView
    }()
    
    private var weatherDetailsStackView: WeatherDetailsStackView = {
        let stackView = WeatherDetailsStackView()
        return stackView
    }()
    
//    private var hourlyForecastView: HourlyForecastView = {
//        let hourlyView = HourlyForecastView()
//        return hourlyView
//    }()
    
//    let exampleForecasts = [
//        ("15°", "sun", "15:00"),
//        ("16°", "sun", "16:00"),
//        ("14°", "sun", "17:00"),
//        ("12°", "sun", "18:00"),
//        ("14°", "sun", "11:00"),
//        ("15°", "sun", "12:00"),
//        ("16°", "sun", "13:00"),
//        ("17°", "sun", "14:00"),
//        ("18°", "sun", "15:00"),
//        ("19°", "sun", "16:00"),
//        ("11°", "sun", "17:00"),
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "DayColorDark")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesBackButton = true
        customizeSearchBarAppearance()
        setUpUI()
//        fetchWeatherData()
        setupViewModelBindings()
        searchController.searchBar.delegate = self
        locationButtonAction()
        weeklyForecastButtonAction()
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
        addButtonsStackView()
        addTempStackView()
        addWeatherDetailsStackView()
//        addHourlyForecastStackView()
    }
    
    private func addButtonsStackView() {
        view.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(view.snp.top).offset(Constants.customSizeButtonStack)
        }
        buttonsStackView.addArrangedSubview(locationButton)
        buttonsStackView.addArrangedSubview(weeklyForecastButton)
    }
    
    private func addTempStackView() {
        view.addSubview(tempStackView)
        tempStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
            make.top.equalTo(buttonsStackView.snp.bottom).offset(Space.xl2)
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
    
//    private func addHourlyForecastStackView() {
//        view.addSubview(hourlyForecastView)
//        hourlyForecastView.snp.makeConstraints { make in
//            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Space.m)
//            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-Space.m)
//            make.top.equalTo(weatherDetailsStackView.snp.bottom).offset(Space.xl3)
//        }
//    }
    
//    private func fetchWeatherData() {
//        hourlyForecastView.updateHourly(
//            date: "November 23",
//            forecasts: exampleForecasts
//        )
//    }
    
    private func setupViewModelBindings() {
        mainPageViewModel.onWeatherDataUpdated = { [weak self] in
            self?.updateUI()
        }
        mainPageViewModel.onError = { [weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: String.errorAlertTitle, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: String.errorAlertButtonTitle, style: .default, handler: nil))
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
    
    private func locationButtonAction() {
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
    
    private func weeklyForecastButtonAction() {
        weeklyForecastButton.addTarget(self, action: #selector(weeklyForecastButtonPressed), for: .touchUpInside)
    }
    
    @objc private func weeklyForecastButtonPressed() {
        let weeklyForecastViewController = WeeklyForecastViewController()
        navigationController?.pushViewController(weeklyForecastViewController, animated: true)
    }
}

extension MainPageView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        mainPageViewModel.updateCity(newCity: searchText)
    }
}

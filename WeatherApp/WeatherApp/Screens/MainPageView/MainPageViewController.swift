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
    static let customStackViewPadding: CGFloat = 78
}

final class MainPageViewController: UIViewController {
    private var mainPageViewModel = MainPageViewModel()
    
    private lazy var dynamicBackgroundView: DynamicBackgroundView = {
        let backgroundView = DynamicBackgroundView(frame: view.bounds, weatherIcon: "01d")
        view.addSubview(backgroundView)
        return backgroundView
    }()
    
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
        button.tintColor = .neutralWhite
        return button
    }()
    
    private var weeklyForecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.weeklyButtonString, for: .normal)
        button.setImage(UIImage.leftArrowButtonIcon, for: .normal)
        button.tintColor = .nightColorDark
        button.backgroundColor = .neutralWhite
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesBackButton = true
        customizeSearchBarAppearance()
        setUpUI()
        setupViewModelBindings()
        searchController.searchBar.delegate = self
        addButtonsActions()
    }
    
    private func updateBackgroundBasedOnWeather() {
        guard let weatherIcon = mainPageViewModel.currentWeather?.weather.first?.icon else {
            dynamicBackgroundView.updateBackground(for: "01d")
            return
        }
        dynamicBackgroundView.updateBackground(for: weatherIcon)
    }
    
    private func customizeSearchBarAppearance() {
        searchController.searchBar.tintColor = UIColor.neutralWhite
        searchController.searchBar.searchTextField.textColor = UIColor.neutralWhite
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: String.searchFieldPlaceHolder,
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        if let textField = searchController.searchBar.value(forKey: String.searchBarKey) as? UITextField {
            textField.backgroundColor = UIColor.neutralWhite.withAlphaComponent(Constants.alphaComponent)
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = textField.bounds
            textField.addSubview(blurView)
            textField.sendSubviewToBack(blurView)
        }
    }
    
    private func setUpUI() {
        view.addSubview(dynamicBackgroundView)
        addButtonsStackView()
        addTempStackView()
        addWeatherDetailsStackView()
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
            make.top.equalTo(buttonsStackView.snp.bottom).offset(Constants.customStackViewPadding)
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
    
    private func updateTempView() {
        tempStackView.updateTemp(
            city: mainPageViewModel.city,
            temperature: mainPageViewModel.getWeatherData(forKey: .temperature),
            description: mainPageViewModel.getWeatherData(forKey: .weatherDescription),
            maxTemp: mainPageViewModel.getWeatherData(forKey: .maxTemp),
            minTemp: mainPageViewModel.getWeatherData(forKey: .minTemp)
        )
    }

    private func updateWeatherDetails() {
        weatherDetailsStackView.updateDetails(
            humidity: mainPageViewModel.getWeatherData(forKey: .humidity),
            windSpeed: mainPageViewModel.getWeatherData(forKey: .maxTemp),
            cloud: mainPageViewModel.getWeatherData(forKey: .clouds)
        )
    }

    private func updateUI() {
        updateTempView()
        updateWeatherDetails()
        updateBackgroundBasedOnWeather()
    }
    
    private func addButtonsActions() {
        locationButton.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        weeklyForecastButton.addTarget(self, action: #selector(weeklyForecastButtonPressed), for: .touchUpInside)
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
    
    @objc private func weeklyForecastButtonPressed() {
        guard let iconName = mainPageViewModel.currentWeather?.weather.first?.icon else { return }
        let weeklyForecastViewController = WeeklyForecastViewController(city: mainPageViewModel.city, iconName: iconName)
        navigationController?.pushViewController(weeklyForecastViewController, animated: true)
    }
}

extension MainPageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        mainPageViewModel.updateCity(newCity: searchText)
    }
}

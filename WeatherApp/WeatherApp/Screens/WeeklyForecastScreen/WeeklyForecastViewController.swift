//
//  WeeklyForecastViewController.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 24.11.24.
//

import UIKit

private enum Constants {
    static let customStackViewHeight: CGFloat = 200
}

class WeeklyForecastViewController: UIViewController {
    private var viewModel = WeeklyForecastViewModel()
    private var city: String
    private var iconName: String
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.m
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: .zero, left: Space.m, bottom: .zero, right: Space.m)
        return stackView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .neutralWhite
        return button
    }()
    
    init(city: String, iconName: String) {
        self.city = city
        self.iconName = iconName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.requiredError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        addDynamicBackgroundView()
        setUpUI()
        setupNavigationButton()
        viewModel.fetchWeeklyForecast(for: city)
    }
    
    private func setUpUI() {
        setupScrollView()
        addHourlyForecastViews()
    }
    
    private func setupNavigationButton() {
        backButton.setTitle(String.backButtonText, for: .normal)
        let image = UIImage.backButtonIcon?.withConfiguration(UIImage.SymbolConfiguration(
            pointSize: Size.m.width,
            weight: .regular
        ))
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func addDynamicBackgroundView() {
        let dynamicBackgroundView = DynamicBackgroundView(frame: view.bounds, weatherIcon: iconName)
        view.insertSubview(dynamicBackgroundView, at: .zero)
        dynamicBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func addHourlyForecastViews() {
        for _ in 0..<5 {
            let hourlyForecastView = HourlyForecastView()
            mainStackView.addArrangedSubview(hourlyForecastView)
            hourlyForecastView.snp.makeConstraints { make in
                make.height.equalTo(Constants.customStackViewHeight)
            }
        }
    }
    
    private func setupBindings() {
        viewModel.onForecastDataUpdated = { [weak self] in
            self?.updateUI()
        }
    }
    
    private func updateUI() {
        let groupedForecasts = viewModel.getGroupedForecasts()
        for (index, (date, forecasts)) in groupedForecasts.enumerated() {
            guard index < mainStackView.arrangedSubviews.count,
                  let hourlyForecastView = mainStackView.arrangedSubviews[index] as? HourlyForecastView else {
                continue
            }
            hourlyForecastView.updateHourly(date: date, forecasts: forecasts)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

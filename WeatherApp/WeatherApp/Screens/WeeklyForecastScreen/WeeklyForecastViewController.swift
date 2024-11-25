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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
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
    
    init(city: String) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.requiredError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "DayColorLight")
        setupBindings()
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
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func addHourlyForecastViews() {
        for _ in 0..<5 {
            let hourlyForecastView = HourlyForecastView()
            contentStackView.addArrangedSubview(hourlyForecastView)
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
            guard index < contentStackView.arrangedSubviews.count,
                  let hourlyForecastView = contentStackView.arrangedSubviews[index] as? HourlyForecastView else {
                continue
            }
            hourlyForecastView.updateHourly(date: date, forecasts: forecasts)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

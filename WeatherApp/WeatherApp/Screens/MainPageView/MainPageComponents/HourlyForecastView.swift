//
//  HourlyForeCastStackView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 23.11.24.
//

import UIKit

final class HourlyForecastView: UIView {
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutralWhite
        label.font = UIFont.systemFont(ofSize: FontConstants.headline2, weight: .light)
        return label
    }()
    
    private var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.itemSize = CGSize(width: 80, height: 100)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    private let cellIdentifier = "HourlyForecastCell"
    private var hourlyForecasts: [(temperature: String, iconName: String, time: String)] = []
    
    private var mainStackView: UIStackView = {
        let stackView = GlassmorphicStackView(
            axis: .vertical,
            spacing: Space.s,
            alignment: .center,
            cornerRadius: CornerRadius.xl2
        )
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addMainStackView()
    }
    
    private func addMainStackView() {
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(hourlyCollectionView)
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hourlyCollectionView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.equalTo(mainStackView.snp.leading)
            make.trailing.equalTo(mainStackView.snp.trailing)
        }
    }
    
    private func setupCollectionView() {
        hourlyCollectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: cellIdentifier)
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
    }
    
    func updateHourly(date: String, forecasts: [(String, String, String)]) {
        dateLabel.text = date
        hourlyForecasts = forecasts
        hourlyCollectionView.reloadData()
    }
}

extension HourlyForecastView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        ) as? HourlyForecastCell else {
            fatalError(String.requiredErrorText)
        }
        
        let forecast = hourlyForecasts[indexPath.row]
        cell.configure(
            temperature: forecast.temperature,
            iconName: forecast.iconName,
            time: forecast.time
        )
        return cell
    }
}

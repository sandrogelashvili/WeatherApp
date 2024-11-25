//
//  WeeklyForecastViewModel.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 25.11.24.
//

import Foundation
import Alamofire
import UIKit

final class WeeklyForecastViewModel {
    private let apiKey = "daa29d04297d8a956e6a6671e018757e"
    private(set) var forecasts: [Forecast] = []
    var onForecastDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchWeeklyForecast(for city: String) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric"
        
        AF.request(url).responseDecodable(of: WeeklyForecastModel.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let forecastResponse):
                self.forecasts = forecastResponse.list
                self.onForecastDataUpdated?()
            case .failure(let error):
                if let httpResponse = response.response, httpResponse.statusCode == 404 {
                    self.onError?(String.incorrectCityNameError)
                } else {
                    self.onError?("\(String.fetchingError) \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getGroupedForecasts() -> [(String, [(String, URL, String)])] {
        var groupedForecasts: [String: [(String, URL, String)]] = [:]
        let sortedForecasts = forecasts.sorted {
            guard let date1 = $0.formattedDate.dateValue(), let date2 = $1.formattedDate.dateValue() else {
                return false
            }
            return date1 < date2
        }
        var lastDate: String?
        for forecast in sortedForecasts {
            let date = forecast.formattedDate
            if lastDate != date {
                lastDate = date
            }
            let time = forecast.formattedTime
            let temperature = "\(Int(forecast.main.temp))°"
            guard let icon = forecast.weather.first?.icon else { continue }
            let iconUrlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            guard let iconUrl = URL(string: iconUrlString) else { continue }
            
            if groupedForecasts[date] == nil {
                groupedForecasts[date] = []
            }
            groupedForecasts[date]?.append((temperature, iconUrl, time))
        }
        return groupedForecasts.sorted { $0.0 < $1.0 }
    }
}

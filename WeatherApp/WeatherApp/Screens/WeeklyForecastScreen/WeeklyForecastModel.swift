//
//  WeeklyForecastModel.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 25.11.24.
//

import Foundation

struct WeeklyForecastModel: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let dtTxt: String?
    let main: Main
    let weather: [ForecastWeather]
    
    enum CodingKeys: String, CodingKey {
        case dtTxt = "dt_txt"
        case main
        case weather
    }

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dtTxt ?? .empty) else { return "" }
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }

    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dtTxt ?? .empty) else { return "" }
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

struct Main: Codable {
    let temp: Double?
}

struct ForecastWeather: Codable {
    let icon: String?
}


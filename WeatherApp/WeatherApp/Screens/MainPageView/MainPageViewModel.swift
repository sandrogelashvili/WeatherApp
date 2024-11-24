//
//  MainPageViewModel.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 24.11.24.
//

import Alamofire

import Foundation
import Alamofire

final class MainPageViewModel {
    
    private let apiKey = "daa29d04297d8a956e6a6671e018757e"
    private(set) var currentWeather: WeatherResponse?
    private(set) var city: String = "Tbilisi"
    
    var onWeatherDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init() {
          fetchWeatherData()
    }
    
    func fetchWeatherData() {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        AF.request(url).responseDecodable(of: WeatherResponse.self) { [weak self] response in
            switch response.result {
            case .success(let weatherResponse):
                self?.currentWeather = weatherResponse
                self?.onWeatherDataUpdated?()
            case .failure(let error):
                if let httpResponse = response.response, httpResponse.statusCode == 404 {
                    self?.onError?("City not found. Please check the name and try again.")
                } else {
                    self?.onError?("Error fetching weather data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateCity(newCity: String) {
            self.city = newCity
            fetchWeatherData()
        }
    
    var temperature: String {
        let temp = currentWeather?.main.temp ?? 0
        return "\(Int(temp))°"
    }
    var weatherDescription: String {
        return currentWeather?.weather.first?.description?.capitalized ?? "No description"
    }
    
    var humidity: String {
        return "\(currentWeather?.main.humidity ?? 0)%"
    }
    
    var windSpeed: String {
        let wind = currentWeather?.wind.speed ?? 0
        return "\(Int(wind)) km/h"
    }
    
    var clouds: String {
        return "\(currentWeather?.clouds.all ?? 0 ) %"
    }
    
    var minTemp: String {
        let min = currentWeather?.main.tempMin ?? 0
        return "Min: \(Int(min))°"
    }
    
    var maxTemp: String {
        let max = currentWeather?.main.tempMax ?? 0
        return "Max: \(Int(max))°"
    }
}

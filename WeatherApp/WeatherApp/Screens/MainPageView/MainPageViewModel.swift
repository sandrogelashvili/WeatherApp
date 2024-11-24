//
//  MainPageViewModel.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 24.11.24.
//

import Foundation
import Alamofire
import CoreLocation

final class MainPageViewModel: NSObject {
    private let locationManager = CLLocationManager()
    private let apiKey = "daa29d04297d8a956e6a6671e018757e"
    private(set) var currentWeather: CurrentWeatherResponse?
    private(set) var city: String = "Tbilisi"
    var currentLocation: CLLocation?
    var onWeatherDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    var latitude: Double? {
        return currentLocation?.coordinate.latitude
    }
    
    var longitude: Double? {
        return currentLocation?.coordinate.longitude
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        checkAuthorizationAndRequestLocation()
    }
    
    func fetchWeatherData(for city: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        AF.request(url).responseDecodable(of: CurrentWeatherResponse.self) { [weak self] response in
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
    
    private func checkAuthorizationAndRequestLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            onError?("Location access is denied. Please enable it in Settings.")
        @unknown default:
            onError?("An unknown location error occurred.")
        }
    }
    
    func fetchWeatherByCoordinates(latitude: Double, longitude: Double) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                self?.onError?("Error retrieving location information: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first, let city = placemark.locality else {
                self?.onError?("City not found for coordinates.")
                return
            }
            self?.city = city
            self?.fetchWeatherData(for: city)
        }
    }
    
    func getWeatherData(forKey key: WeatherDataKey) -> String {
        switch key {
        case .temperature:
            return "\(Int(currentWeather?.main.temp ?? 0))°"
        case .weatherDescription:
            return currentWeather?.weather.first?.description?.capitalized ?? "No description"
        case .humidity:
            return "\(currentWeather?.main.humidity ?? 0)%"
        case .windSpeed:
            return "\(Int(currentWeather?.wind.speed ?? 0)) km/h"
        case .clouds:
            return "\(currentWeather?.clouds.all ?? 0) %"
        case .minTemp:
            return "Min: \(Int(currentWeather?.main.tempMin ?? 0))°"
        case .maxTemp:
            return "Max: \(Int(currentWeather?.main.tempMax ?? 0))°"
        }
    }
    
    enum WeatherDataKey {
        case temperature, weatherDescription, humidity, windSpeed, clouds, minTemp, maxTemp
    }
    
    func updateCity(newCity: String) {
        self.city = newCity
        fetchWeatherData(for: newCity)
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}

extension MainPageViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            onError?("Location access is denied. Please enable it in Settings.")
        case .notDetermined:
            break
        @unknown default:
            onError?("An unknown authorization error occurred.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchWeatherByCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onError?("Failed to get location: \(error.localizedDescription)")
    }
}

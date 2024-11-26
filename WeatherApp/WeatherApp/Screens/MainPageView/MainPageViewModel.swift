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
    private let cacheManager = WeatherCacheManager()
    var isLoading: ((Bool) -> Void)?
    
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
        isLoading?(true)
        if let cachedData = cacheManager.loadWeatherData(for: city, dataType: "current"), !cacheManager.isCacheExpired(for: city, dataType: "current") {
               if let cachedWeather = try? JSONDecoder().decode(CurrentWeatherResponse.self, from: cachedData) {
                   self.currentWeather = cachedWeather
                   self.onWeatherDataUpdated?()
                   isLoading?(false)
                   return
               }
           }
           let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
           
           AF.request(url).responseDecodable(of: CurrentWeatherResponse.self) { [weak self] response in
               guard let self = self else { return }
               switch response.result {
               case .success(let weatherResponse):
                   self.currentWeather = weatherResponse
                   if let data = try? JSONEncoder().encode(weatherResponse) {
                       self.cacheManager.saveWeatherData(data, for: city, dataType: "current")
                   }
                   self.onWeatherDataUpdated?()
               case .failure(let error):
                   if let httpResponse = response.response, httpResponse.statusCode == 404 {
                       self.onError?(String.incorrectCityNameError)
                   } else {
                       self.onError?("\(String.fetchingError) \(error.localizedDescription)")
                   }
               }
               self.isLoading?(false)
           }
       }
    
    private func checkAuthorizationAndRequestLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            onError?(String.locationAccessError)
        @unknown default:
            onError?(String.unknownLocationError)
        }
    }
    
    func fetchWeatherByCoordinates(latitude: Double, longitude: Double) {
        isLoading?(true)
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                self.onError?(" \(String.coordinatesLocationError) \(error.localizedDescription)")
                self.isLoading?(false)
                return
            }
            
            guard let placemark = placemarks?.first, let city = placemark.locality else {
                self.onError?(String.cityWithCoordinatesError)
                self.isLoading?(false)
                return
            }
            self.city = city
            self.fetchWeatherData(for: city)
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
    
    func getCityName() -> String {
        currentWeather?.name ?? .empty
    }
}

extension MainPageViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            onError?(String.locationAccessError)
        case .notDetermined:
            break
        @unknown default:
            onError?(String.unknownAuthorisationError)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchWeatherByCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onError?("\(String.getLocationFailError) \(error.localizedDescription)")
    }
}

//
//  WeatherCacheManager.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 26.11.24.
//

import Foundation

final class WeatherCacheManager {
    
    private let cacheExpirationTime: TimeInterval = 60 * 60
    private let fileManager = FileManager.default
    private var documentsDirectory: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func loadWeatherData(for city: String, dataType: String) -> Data? {
        let fileURL = getFileURL(for: city, dataType: dataType)
        return try? Data(contentsOf: fileURL)
    }
    
    func isCacheExpired(for city: String, dataType: String) -> Bool {
        let timestampFileURL = getTimestampFileURL(for: city, dataType: dataType)
        
        guard let timestampData = try? Data(contentsOf: timestampFileURL),
              let timestamp = try? JSONDecoder().decode(TimeInterval.self, from: timestampData) else {
            return true
        }
        
        return Date().timeIntervalSince1970 - timestamp > cacheExpirationTime
    }
    
    func saveWeatherData(_ data: Data, for city: String, dataType: String) {
        let fileURL = getFileURL(for: city, dataType: dataType)
        let timestampFileURL = getTimestampFileURL(for: city, dataType: dataType)
        
        try? data.write(to: fileURL)
        let timestamp = Date().timeIntervalSince1970
        let timestampData = try? JSONEncoder().encode(timestamp)
        try? timestampData?.write(to: timestampFileURL)
    }
    private func getFileURL(for city: String, dataType: String) -> URL {
        let fileName = "\(city)_\(dataType).json"
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    private func getTimestampFileURL(for city: String, dataType: String) -> URL {
        let fileName = "\(city)_\(dataType)_timestamp.json"
        return documentsDirectory.appendingPathComponent(fileName)
    }
}

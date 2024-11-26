//
//  String+Extension.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 19.11.24.
//

import Foundation

extension String {
    // MARK: - Custom TextField
    static let usernamePlaceholder: String = "Enter Username"
    static let passwordPlaceholder: String = "Enter password"
    
    // MARK: - Login Screen
    static let welcomeLabelText: String = "Welcome!"
    static let detailsLabelText: String = "Please enter your details below"
    static let usernameLabelText: String = "Username"
    static let passwordLabelText: String = "Password"
    
    // MARK: - Onboarding Screen
    /// Title
    static let firstPageTitle: String = "Welcome to WeatherApp"
    static let secondPageTitle: String = "5-Day Forecast"
    static let thirdPageTitle: String = "Get Started"
    /// Description
    static let firstPageDescription: String = "Get real-time weather updates for your current location or search for cities around the world."
    static let secondPageDescription: String = "Plan ahead with a detailed 5-day forecast. View weather predictions for the upcoming days."
    static let thirdPageDescription: String = "Let's dive in!"
    /// ImageName
    static let firstPageImageName: String = "SunnyDay"
    static let secondPageImageName: String = "SnowyDay"
    static let thirdPageImageName: String = "RainyDay"
    
    static let loginButtonTitle: String = "Log In"
    static let continueButtonTitle: String = "Continue"
    
    // MARK: - MainPage Screen
    static let searchFieldPlaceHolder: String = "Search for a city"
    static let searchBarKey: String = "searchField"
    static let hourlyCellIdentifier: String = "HourlyForecastCell"
    static let weeklyButtonString: String = "Weekly"
    static let errorAlertTitle: String = "Oops"
    static let errorAlertButtonTitle: String = "OK"
    
    // MARK: - WeeklyForecast Screen
    static let backButtonText: String = "Back"
    
    // MARK: - General, Error Handling
    static let empty = ""
    static let requiredError: String = "init(coder:) has not been implemented"
    static let incorrectCityNameError: String = "City not found. Please check the name and try again."
    static let fetchingError: String = "Error fetching weather data:"
    static let locationAccessError: String = "Location access is denied. Please enable it in Settings."
    static let unknownLocationError: String = "An unknown location error occurred."
    static let coordinatesLocationError: String = "Error retrieving location information:"
    static let cityWithCoordinatesError: String = "City not found for coordinates."
    static let unknownAuthorisationError: String = "An unknown authorization error occurred."
    static let getLocationFailError: String = "Failed to get location:"
}

extension String {
    func dateValue(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
    }
}

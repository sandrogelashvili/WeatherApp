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
    static let firstPageTitle: String = "Welcome"
    static let secondPageTitle: String = "Stay Organized"
    static let thirdPageTitle: String = "Get Started"
    /// Description
    static let firstPageDescription: String = "Discover new features."
    static let secondPageDescription: String = "Manage tasks with ease."
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
    
    // MARK: - General
    static let empty = ""
    static let requiredErrorText: String = "init(coder:) has not been implemented"
}

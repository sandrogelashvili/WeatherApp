//
//  AppColors+Extension.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 18.11.24.
//

import UIKit

extension UIColor {
    
    // MARK: - Neutral
    public static var neutralBlack: UIColor { UIColor(hex: 0x1A120B) }
    public static var neutralWhite: UIColor { UIColor(hex: 0xFFFFFF) }
    
    // MARK: - Day
    public static var dayColorDark: UIColor {UIColor(hex: 0x3B6193)}
    public static var dayColorLight: UIColor {UIColor(hex: 0x89A5C9)}
    
    // MARK: - Night
    public static var nightColorDark: UIColor {UIColor(hex: 0x05061A)}
    public static var nightColorLight: UIColor {UIColor(hex: 0x364368)}
    
    // MARK: - Cloudy
    // day
    public static var dayCloudyColorDark: UIColor {UIColor(hex: 0x5E6A7B)}
    public static var dayCloudyColorLight: UIColor {UIColor(hex: 0x97A4B2)}
    // night
    public static var nightCloudyColorDark: UIColor {UIColor(hex: 0x1B212F)}
    public static var nightCloudyColorLight: UIColor {UIColor(hex: 0x273545)}
    
    // MARK: - LaunchScreen
    public static var launchScreenBlue: UIColor {UIColor(hex: 0x6990C5)}
    public static var launchScreenGreen: UIColor {UIColor(hex: 0x313922)}
    
    // MARK: - Snowy
    public static var daySnowyColorDark: UIColor {UIColor(hex: 0x5A6E8D)}
    public static var daySnowyColorLight: UIColor {UIColor(hex: 0x90A2BF)}

    // MARK: - Gray
    public static var grayPrimary: UIColor { UIColor(hex: 0x545454) }
    public static var grayLight: UIColor { UIColor(hex: 0xE9E9E9) }
    public static var graLight2: UIColor { UIColor(hex: 0xA3A3A3) }
}

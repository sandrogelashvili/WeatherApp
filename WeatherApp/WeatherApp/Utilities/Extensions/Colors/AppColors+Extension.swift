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
    
    // MARK: - Yellow
    
    public static var yellowPrimary: UIColor { UIColor(hex: 0xe9c429) }
    
    // MARK: - Blue
    
    public static var bluePrimary: UIColor {UIColor(hex: 0x226ba3)}

    
    // MARK: - Gray
    
    public static var grayPrimary: UIColor { UIColor(hex: 0x545454) }
    public static var graySecondary: UIColor { UIColor(hex: 0x999999) }
    public static var grayTertiary: UIColor { UIColor(hex: 0xD1D1D1) }
    public static var grayLight: UIColor { UIColor(hex: 0xE9E9E9) }
    public static var grayExtraLight: UIColor { UIColor(hex: 0xF0F0F0) }
    public static var grayExtraLight2: UIColor { UIColor(hex: 0xF9F9F9) }
    
    // MARK: - System
    
    public static var systemError: UIColor { UIColor(hex: 0xFF3B30) }
    public static var systemSuccess: UIColor { UIColor(hex: 0x4CAF50) }
    public static var systemWarning: UIColor { UIColor(hex: 0xFFBB33) }
    public static var systemLink: UIColor { UIColor(hex: 0x007AFF) }
}

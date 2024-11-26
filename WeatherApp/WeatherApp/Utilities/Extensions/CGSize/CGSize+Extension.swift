//
//  CGSize+Extension.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 16.11.24.
//

import Foundation

extension CGSize {
    init(square side: CGFloat) {
        self.init(width: side, height: side)
    }
}

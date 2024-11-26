//
//  OnboardingViewModel.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 18.11.24.
//

import Foundation
import UIKit

final class OnboardingViewModel {
    
    enum Page: CaseIterable {
        case firstPage, secondPage, thirdPage

        var title: String {
            switch self {
            case .firstPage: return String.firstPageTitle
            case .secondPage: return String.secondPageTitle
            case .thirdPage: return String.thirdPageTitle
            }
        }
        
        var description: String {
            switch self {
            case .firstPage: return String.firstPageDescription
            case .secondPage: return String.secondPageDescription
            case .thirdPage: return String.thirdPageDescription
            }
        }
        
        var dayImage: UIImage? {
            switch self {
            case .firstPage: return UIImage.sunnyDayImage
            case .secondPage: return UIImage.snowyDayImage
            case .thirdPage: return UIImage.rainyDayImage
            }
        }
    }
    
    var pages: [Page] = Page.allCases
    var currentPageIndex: Int = .zero
    
    func getCurrentPage() -> Page {
        return pages[currentPageIndex]
    }
    
    func getNextPage() {
        if currentPageIndex < pages.count - 1 {
            currentPageIndex += 1
        }
    }
    
    func getPreviousPage() {
        if currentPageIndex > .zero {
            currentPageIndex -= 1
        }
    }
    
    func getButtonTitle() -> String {
        return currentPageIndex == pages.count - 1 ? String.loginButtonTitle : String.continueButtonTitle
    }
}

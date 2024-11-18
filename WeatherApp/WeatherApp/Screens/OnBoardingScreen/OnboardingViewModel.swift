//
//  OnboardingViewModel.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 18.11.24.
//

import Foundation

final class OnboardingViewModel {
    enum Page: CaseIterable {
        case firstPage, secondPage, thirdPage

        var title: String {
            switch self {
            case .firstPage: return "Welcome"
            case .secondPage: return "Stay Organized"
            case .thirdPage: return "Get Started"
            }
        }
        
        var description: String {
            switch self {
            case .firstPage: return "Discover new features."
            case .secondPage: return "Manage tasks with ease."
            case .thirdPage: return "Let's dive in!"
            }
        }
        
        var imageName: String {
            switch self {
            case .firstPage: return "SunnyDay"
            case .secondPage: return "SnowyDay"
            case .thirdPage: return "RainyDay"
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
        return currentPageIndex == pages.count - 1 ? "Log In" : "Continue"
    }
}

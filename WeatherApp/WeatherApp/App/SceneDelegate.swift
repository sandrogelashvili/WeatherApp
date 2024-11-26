//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 15.11.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let splashScreenVC = SplashScreenViewController()
        window?.rootViewController = splashScreenVC
        window?.makeKeyAndVisible()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showNextScreen()
        }
    }
    
    private func showNextScreen() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: LaunchKey.hasLaunchedBefore)
        let initialViewController: UIViewController
        
        if hasLaunchedBefore {
            initialViewController = LoginViewController()
        } else {
            let onboardingViewModel = OnboardingViewModel()
            initialViewController = OnboardingViewController(viewModel: onboardingViewModel)
            UserDefaults.standard.set(true, forKey: LaunchKey.hasLaunchedBefore)
        }
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        navigationController.setNavigationBarHidden(false, animated: false)
        
        self.window?.rootViewController = navigationController
    }
}

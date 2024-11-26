//
//  SplashScreenViewController.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 26.11.24.
//

import UIKit
import SnapKit

class SplashScreenViewController: UIViewController {
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.splashScreenImage
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "WeatherApp"
        label.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        label.textColor = .neutralWhite
        label.textAlignment = .center
        label.alpha = .zero
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setupTitleLabel()
        animateTextLetterByLetter()
    }
    
    private func setupBackgroundImage() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(Space.l)
        }
    }
    
    private func animateTextLetterByLetter() {
        let fullText = titleLabel.text ?? .empty
        var currentText = String.empty
        titleLabel.text = .empty
        let totalAnimationDuration: TimeInterval = 1.5
        let delayPerCharacter = totalAnimationDuration / Double(fullText.count)
        
        UIView.animate(withDuration: 0.5, animations: {
                    self.titleLabel.alpha = 1.0
        })
        
        for (index, letter) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayPerCharacter * Double(index)) {
                currentText.append(letter)
                self.titleLabel.text = currentText
            }
        }
    }
}

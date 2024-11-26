//
//  ReusableButton.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 19.11.24.
//

import UIKit

final class CustomButton: UIButton {
    
    private var actionClosure: (() -> Void)?
    
    init(
        title: String,
        backgroundColor: UIColor = .neutralBlack,
        cornerRadius: CGFloat = CornerRadius.xl,
        font: UIFont = .systemFont(ofSize: FontConstants.body1, weight: .bold)
    ) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        setTitleColor(.neutralWhite, for: .normal)
        titleLabel?.font = font
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.requiredError)
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(title: String, backgroundColor: UIColor? = nil, font: UIFont? = nil) {
        setTitle(title, for: .normal)
        if let bgColor = backgroundColor {
            self.backgroundColor = bgColor
        }
        if let customFont = font {
            titleLabel?.font = customFont
        }
    }
    
    func setAction(_ action: @escaping () -> Void) {
        self.actionClosure = action
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        actionClosure?()
    }
}

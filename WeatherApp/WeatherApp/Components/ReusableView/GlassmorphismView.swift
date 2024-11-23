//
//  GlassmorphismView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 23.11.24.
//

import UIKit

private enum Constants {
    static let alphaComponent: CGFloat = 0.1
}

final class GlassmorphicStackView: UIStackView {
    
    private var blurView = UIVisualEffectView()
    
    init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = Space.m, alignment: Alignment = .center, cornerRadius: CGFloat = CornerRadius.xl2) {
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        
        applyGlassmorphism(cornerRadius: cornerRadius)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        applyGlassmorphism(cornerRadius: CornerRadius.xl2)
    }
    
    private func applyGlassmorphism(cornerRadius: CGFloat) {
        self.backgroundColor = UIColor.white.withAlphaComponent(Constants.alphaComponent)
        
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
        self.sendSubviewToBack(blurView)
        
        self.layoutMargins = UIEdgeInsets(top: Space.s, left: Space.m, bottom: Space.s, right: Space.m)
        self.isLayoutMarginsRelativeArrangement = true
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = self.bounds
    }
}

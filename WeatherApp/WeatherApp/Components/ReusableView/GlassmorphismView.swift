//
//  GlassmorphismView.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 23.11.24.
//

import UIKit

class GlassmorphicStackView: UIStackView {
    
    private var blurView = UIVisualEffectView()
    
    init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 8, alignment: Alignment = .center, cornerRadius: CGFloat = 16) {
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        
        applyGlassmorphism(cornerRadius: cornerRadius)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        applyGlassmorphism(cornerRadius: 16)
    }
    
    private func applyGlassmorphism(cornerRadius: CGFloat) {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
        self.sendSubviewToBack(blurView)
        
        self.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        self.isLayoutMarginsRelativeArrangement = true
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = self.bounds
    }
}

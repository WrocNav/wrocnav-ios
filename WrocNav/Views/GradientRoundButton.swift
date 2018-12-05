//
//  GradientRoundButton.swift
//  I.R.B.A
//
//  Created by Kacper Raczy on 26.02.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class GradientRoundButton: RoundButton {
    
    @IBInspectable
    var color1: UIColor = UIColor.clear {
        didSet{
            setUpGradient()
        }
    }
    
    @IBInspectable
    var color2: UIColor = UIColor.clear {
        didSet {
            setUpGradient()
        }
    }
    
    private func setUpGradient() {
        let colors = [color1, color2]
        
        setUpGradient(colors: colors)
    }
    
    private func setUpGradient(colors: [UIColor]) {
        if let sublayer = self.layer.sublayers?.first as? CAGradientLayer {
            sublayer.removeFromSuperlayer()
        }
        
        applyGradient(withColours: colors, gradientOrientation: .horizontal)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setUpGradient()
    }

}

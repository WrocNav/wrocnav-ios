//
//  GradientRoundView.swift
//  VetExpert
//
//  Created by Kacper Raczy on 09.02.2018.
//  Copyright © 2018 Kacper Rączy. All rights reserved.
//

import UIKit

@IBDesignable
class GradientRoundView: RoundView {
    
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
    
    @IBInspectable
    var orientation: Int = 0 {
        didSet {
            setUpGradient()
        }
    }
    
    private var gradientOrientation: GradientOrientation {
        return (orientation % 2 == 0) ? .horizontal : .vertical
    }
    
    override func setUp() {
        super.setUp()
        
        self.clipsToBounds = true
        setUpGradient()
    }
    
    private func setUpGradient() {
        let colors = [color1, color2]
        
        setUpGradient(colors: colors)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setUpGradient()
    }
    
    private func setUpGradient(colors: [UIColor]) {
        if let sublayer = self.layer.sublayers?.first as? CAGradientLayer {
            sublayer.removeFromSuperlayer()
        }
        
        applyGradient(withColours: colors, gradientOrientation: gradientOrientation)
    }
    
}

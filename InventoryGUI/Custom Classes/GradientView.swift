//
//  GradientView.swift
//  Smack
//
//  Created by Mauricio Figueroa on 9/21/17.
//  Copyright © 2017 Mauricio Figueroa. All rights reserved.
//

import UIKit

@IBDesignable //render inside the storyboard
class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8549019608, alpha: 0.4882277397) {
        didSet {
            self.setNeedsLayout()
        }//end didSet
    }//end topColor
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.1725490196, green: 0.831372549, blue: 0.8470588235, alpha: 0.5) {
        didSet {
            self.setNeedsLayout()
        }//end didSet
    }//end bottomColor
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y:0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }//end layoutSubviews
}//end class

//
//  DesignView.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 23.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DesignView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 25
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowOpacity: Float = 0.2
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity
    }
}

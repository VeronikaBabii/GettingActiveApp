//
//  ModalTaskView.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 27.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    // rounded corners for modal pop-up
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}

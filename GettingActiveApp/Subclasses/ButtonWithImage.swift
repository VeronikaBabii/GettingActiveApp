//
//  ButtonWithImage.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 08.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import UIKit

class ButtonWithImage: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: (bounds.width - 35))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: (imageView?.frame.width)!, bottom: 0, right: 5)
        }
    }

}

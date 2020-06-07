////
////  SelectButton.swift
////  GettingActiveApp
////
////  Created by Veronika Babii on 07.06.2020.
////  Copyright © 2020 GettingActiveApp. All rights reserved.
////
//
//import UIKit
//
//class ButtonSelection: UIButton {
//
//    var isOn = false
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initButton()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        initButton()
//    }
//    
//    func initButton() {
//        layer.borderWidth = 2
//        layer.borderColor = Colors.lightGray.cgColor
//        layer.cornerRadius = frame.size.height/2
//        
//        tintColor = UIColor.black
//        backgroundColor = Colors.lightGray
//        
//        addTarget(self, action: #selector(ButtonSelection.buttonPressed), for: .touchUpInside)
//    }
//    
//    @objc func buttonPressed() {
//        activateButton(bool: !isOn)
//    }
//    
//    func activateButton(bool: Bool) {
//        isOn = bool
//        
//        let color = bool ? Colors.GAgreen : Colors.lightGray
//        let titleColor = bool ? UIColor.white : UIColor.black
//        
//        setTitleColor(titleColor, for: .normal)
//        backgroundColor = color
//    }
//    
//
//}

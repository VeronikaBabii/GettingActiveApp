import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = Colors.GAgreen.cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    // buttons from authorization
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = Colors.GAgreen
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.black
    }
    
    // buttons for poll
    static func styleGreyButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.lightGray.cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.black
        button.backgroundColor = Colors.lightGray
    }
    
    static func unactiveContinueButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.lightGray.cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.white
        button.backgroundColor = Colors.lightGray
    }
    
    static func activeContinueButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.lightGray.cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.black
        button.backgroundColor = Colors.lightGray
    }
    
    static func styleRedButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.red
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}

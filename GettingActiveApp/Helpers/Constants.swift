import Foundation
import UIKit

struct Constants {
    
    struct Storyboard {
        // shortcut to reference TabBarVC storyboard
        // static - so we can access it without having to create instances of the structure
        static let tabBarViewController = "TabBarVC"
        static let mainViewController = "MainVC"
        static let pollViewController = "PollVC"
    }
}

struct Colors {
    static let lightGray = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    static let darkGray = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    static let GAgreen = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    static let selectedRed = UIColor.init(red: 247/255, green: 72/255, blue: 72/255, alpha: 1)
    
}

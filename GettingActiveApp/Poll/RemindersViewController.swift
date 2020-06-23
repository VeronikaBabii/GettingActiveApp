//
//  RemindersViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 07.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import UIKit
import UserNotifications

class RemindersViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.activeButton(continueButton)
        
        
    }
    
    @IBAction func allowNotifButton(_ sender: Any) {
        // ask for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (grantedAccess, error) in
        }
        
        //
        
        
        transitionToTasks()
    }

    func transitionToTasks() {
        let tabBarViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarViewController) as? TabBarViewController
        
        view.window?.rootViewController = tabBarViewController
        view.window?.makeKeyAndVisible()
    }
}

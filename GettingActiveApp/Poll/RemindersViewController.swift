//
//  RemindersViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 07.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import UIKit

class RemindersViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.activeButton(continueButton)
    }

}

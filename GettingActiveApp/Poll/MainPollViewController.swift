//
//  MainPollViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 08.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import UIKit

class MainPollViewController: UIViewController {

    @IBOutlet weak var nowButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.activeButton(nowButton)
        Utilities.unactiveButton(laterButton)
        
    }
    
}

//
//  CategoriesViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 07.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var categoryView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.isEnabled = false
        Utilities.unactiveButton(continueButton)
        
        categoryView.layer.cornerRadius = categoryView.frame.height / 2
    }
    
    @IBAction func categoryTapped(_ sender: Any) {
        
        // style views as selected
       
        
        // enable continue button
        continueButton.isEnabled = true
        continueButton.tintColor = UIColor.white
        continueButton.backgroundColor = Colors.GAgreen
        
        print("Tapped")
    }
    
}

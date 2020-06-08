//
//  CategoriesViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 07.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CategoriesViewController: UIViewController {

    var db = Firestore.firestore()
    var categoriesArray : [String] = ["Соціалізація", "Розвиток", "Спорт", "Догляд",
                   "Продуктивність", "Краса", "Відпочинок", "Здоров'я"]
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet var categoriesButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // assign categories to buttons
        for button in categoriesButtons {
            button.setTitle(categoriesArray[categoriesButtons.firstIndex(of: button)!], for: [])
        }
        
        // disable continue button
        continueButton.isEnabled = false
        Utilities.unactiveButton(continueButton)
        
        // style unselected buttons
        categoriesButtons.forEach({Utilities.unactiveButton($0)})
        
    }
    
    @IBAction func categoryTapped(_ sender: UIButton) {
        
         print("Tapped")
        
        // enable continue button
        continueButton.isEnabled = true
        continueButton.tintColor = UIColor.white
        continueButton.backgroundColor = Colors.GAgreen
        
        if sender.tintColor == UIColor.black {
           // style as selected button
            sender.tintColor = UIColor.white
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.backgroundColor = Colors.GAgreen
        
        } else if sender.tintColor == UIColor.white {
            // style as unselected button
            sender.tintColor = UIColor.black
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.backgroundColor = Colors.lightGray
        }
    }
    
    // get selected categories and push to user's coll
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        let userID = Auth.auth().currentUser!.uid
        let userDocRef = db.collection("users").document(userID)
        
        
    }
}

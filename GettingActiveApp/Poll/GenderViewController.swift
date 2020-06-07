//
//  GenderViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 07.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class GenderViewController: UIViewController {
    
    var db = Firestore.firestore()

    @IBOutlet weak var menButton: UIButton!
    @IBOutlet weak var womenButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.isEnabled = false

        Utilities.styleGreyButton(menButton)
        Utilities.styleGreyButton(womenButton)
        Utilities.unactiveContinueButton(continueButton)
    }
    
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        
        // enable continue button, when gender button is tapped
        continueButton.isEnabled = true
        continueButton.tintColor = UIColor.white
        continueButton.backgroundColor = Colors.GAgreen
        
        // ability to choose only one button at a time
        menButton.tintColor = UIColor.black
        menButton.backgroundColor = Colors.lightGray
        womenButton.tintColor = UIColor.black
        womenButton.backgroundColor = Colors.lightGray
        
        sender.tintColor = UIColor.white
        sender.backgroundColor = Colors.GAgreen
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        getSelectedGender()
    }
    
    // get selected gender, get current user, create gender field for him in db and write his gender there
    func getSelectedGender() {
        
        let userID = Auth.auth().currentUser!.uid
        let userDocRef = db.collection("users").document(userID)
        
        if menButton.tintColor == UIColor.white {
            print("Men gender is selected")
            userDocRef.setData([ "gender": "Men" ], merge: true)
            
        } else if womenButton.tintColor == UIColor.white {
            print("Women gender is selected")
            userDocRef.setData([ "gender": "Women" ], merge: true)
            
        }
    }
}

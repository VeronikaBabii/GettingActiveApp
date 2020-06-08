//
//  BirthdayViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 07.06.2020.
//  Copyright © 2020 GettingActiveApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class BirthdayViewController: UIViewController {
    
    var db = Firestore.firestore()

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.isEnabled = false
        Utilities.unactiveButton(continueButton)
        
        setUpDatePicker()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        saveUserBirthday()
    }
    
    func setUpDatePicker() {
        // only date mode
        datePicker.datePickerMode = .date
        
        // get local date format from user settings
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        
        // when datePicker is tapped
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // set boundaries
        let minDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        let maxDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = maxDate
        
        // default date
        datePicker.date = Calendar.current.date(byAdding: .year, value: -19, to: Date())!    }
    
    @objc func dateChanged() {
         // enable continue button, when datePicker is tapped
         continueButton.isEnabled = true
         continueButton.tintColor = UIColor.white
         continueButton.backgroundColor = Colors.GAgreen
    }
    
    func saveUserBirthday() {
        // get date from picker
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let userBirthday = formatter.string(from: datePicker.date)
        print(userBirthday)
        
        // push current user birthday to new field in db
        let userID = Auth.auth().currentUser!.uid
        let userDocRef = db.collection("users").document(userID)
        
        userDocRef.setData(["birthday": userBirthday], merge: true)
    }
}

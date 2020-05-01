//
//  SettingsTableViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 25.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SettingsTableViewController: UITableViewController {
    
    var db = Firestore.firestore()
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var aboutButton: UIView!
    
    @IBOutlet weak var firstnameTextfield: UITextField!
    
    @IBOutlet weak var datePickerTextfield: UITextField!
    
    @IBOutlet weak var genderPickerTextfield: UITextField!
    
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserFirstname()
        setDatePicker()
        setGenderSelection()
    }
        
    // log out
    @IBAction func logoutButtonTapped(_ sender: Any) {
       let mainVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController) as? ViewController
        
        view.window?.rootViewController = mainVC
        view.window?.makeKeyAndVisible()
    }
    
    // redirect to about us file on web
    @IBAction func aboutButtonTapped(_ sender: Any) {
        
    }
    
    // configure gender selection
    func setGenderSelection() {
        
    }
    
    // configure date picker
    func setDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        // set min and max
        let minDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        let maxDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = maxDate
        
        // dismiss date picker on tap outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        datePickerTextfield.inputView = datePicker
    }
    
    // dismiss anything that open on view tap
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // format date
    @objc func dateChanged(datePicker: UIDatePicker) {
        // convert to readable format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        datePickerTextfield.text = dateFormatter.string(from: datePicker.date)
    }
    
    // get user firstname and add it to the name field
    func setUserFirstname() {
        if let userId = Auth.auth().currentUser?.uid {
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let currentUserDoc = snapshot?.documents.first(where: { ($0["uid"] as? String) == userId }) {
                    let userFirstname = currentUserDoc["firstname"] as! String
                    self.firstnameTextfield.text = "\(userFirstname)"
                }
            }
        }
        }
    }
    
    // update "firstname" parameter data in the db if user change his name in settings
    
    
    // add new parameters "birthday" and "gender" to the db when user add it in settings
    
    
}

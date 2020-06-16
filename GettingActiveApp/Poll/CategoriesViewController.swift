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
    var categoriesArray: [String] = ["Соціалізація", "Розвиток", "Спорт", "Догляд",
    "Продуктивність", "Відпочинок", "Здоров'я", "Хобі"]
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet var categoriesButtons: [UIButton]!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0

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
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    // check whether user selected at least 3 categories
    func validateCategories(categories: [String]) -> String? {
        if categories.count < 3 {
            return "Please select at least 3 categories!"
        }
        
         return nil
    }
    
    // get selected categories and push to user's coll
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        
        let userID = Auth.auth().currentUser!.uid
        let userDocRef = db.collection("users").document(userID)
        var categories : [String] = []
        
        for button in categoriesButtons {
            if button.tintColor == UIColor.white {
                categories.append(button.title(for: .normal)!)
                userDocRef.setData(["categories": categories ], merge: true)
            }
        }
        
        // push to user's coll tasks from collection with selected names
        
        //>>>>>>>>> here I need copy one document from each category collection to user's collection
        
        let error = validateCategories(categories: categories)
        
        if error != nil {
            print("Categories wasn't selected")
            showError(error!)
        } else {
            for category in categories {
                let categoryCollRef = db.collection("categories").document("categories").collection("\(category)")
                print(category)
                
                categoryCollRef.getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        if let snapshot = querySnapshot {
                            for document in snapshot.documents {
                                let data = document.data()
                                let batch = self.db.batch()
                                let docset = querySnapshot
                                
                                let newCollRef = userDocRef.collection("tasks").document()
                                
                                docset?.documents.forEach {_ in batch.setData(data, forDocument: newCollRef)}
                                
                                batch.commit(completion: { (error) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("Successfuly copied doc")
                                    }
                                })
                            }
                        }
                         self.transitionToNextQuestion()
                    }
                }
            }
        }
    }
    
    func transitionToNextQuestion() {
        let genderViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.genderViewController) as? GenderViewController
        
        view.window?.rootViewController = genderViewController
        view.window?.makeKeyAndVisible()
    }
}

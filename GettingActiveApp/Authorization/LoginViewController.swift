//
//  LoginViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 19.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0 // hide the error label
        
        // style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    func validateFields() -> String? {
        
        // check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields!"
        }
        return nil
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let mainVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController) as? ViewController
        
        view.window?.rootViewController = mainVC
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // validate the fields
        let error = validateFields()
        
        // there's an error, bc something wrong with the fields, so show error message
        if error != nil {
            showError(error!)
        } else { // no errors
            
            // create cleaned versions of the data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                
                // couldn't sign in
                if err != nil {
                    self.errorLabel.text = err!.localizedDescription
                    self.errorLabel.alpha = 1
                } else { // no errors, the user signed in successfully
                    self.transitionToHome()
                    
                    self.pushTasksIfThereArent()
                }
            }
        }
    }
    
    // if there are no tasks in allTasks collection
    // that means that user registered, but didn't take a poll,
    // push firstBundle tasks to the user tasks collection
    func pushTasksIfThereArent() {
        let userID = Auth.auth().currentUser!.uid
        let userTasksCollRef = db.collection("users").document(userID).collection("tasks")

        userTasksCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                var count = 0
                for _ in queryShapshot!.documents {
                    count += 1
                }

                if count == 0 {
                    print("No tasks")
                    
                    // copy from firstBundle to user coll and display
                    let tasksFirstBundleCollRef = self.db.collection("tasks").document("firstBundle").collection("tasks")
                    
                    tasksFirstBundleCollRef.getDocuments {
                        (querySnapshot, err) in
                        
                        if let err = err {
                            print("Error getting documents: \(err.localizedDescription)")
                        } else {
                            if let snapshot = querySnapshot {
                                for document in snapshot.documents {
                                    let data = document.data()
                                    let batch = self.db.batch()
                                    let docset = querySnapshot
                                    
                                    let newCollRef = userTasksCollRef.document()
                                    
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
                        }
                    }
                }
            }
        }
    }
    
    // method to show error message on the page
    func showError(_ message:String) {
        errorLabel.text = message // show error message in our label
        errorLabel.alpha = 1 // visible
    }
    
    // method to go to the home screen (sign rootVC to any other VC we're now)
    func transitionToHome() {
        // reference to TabBarViewController (this returns view controller, so we cast it as (?as) TabBarViewController type)
        let tabBarViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarViewController) as? TabBarViewController
        
        // swap - sign homeVC to the rootVC
        view.window?.rootViewController = tabBarViewController
        // show homeVC as rootVC instead
        view.window?.makeKeyAndVisible()
    }
}

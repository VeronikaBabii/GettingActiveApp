//
//  SignUpViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 19.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    var db = Firestore.firestore()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    // copy tasks for user from general tasks collection to user's own tasks collection
    func copyTasks() {
        copyFirstBundle()
        //copySecondBundle()
    }
    
    // copy tasks from first bundle to users coll
    func copyFirstBundle() {
        // copy from db.collection("tasks").document("firstBundle").collection("tasks") = tasksFirstBundleCollRef
        // to db.collection("users").document(userID) = userDocRef
        
        let userID = Auth.auth().currentUser!.uid
        let userRef = db.collection("users").document(userID)
        let tasksFirstBundleCollRef = db.collection("tasks").document("firstBundle").collection("tasks")
        
        tasksFirstBundleCollRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err.localizedDescription)")
            } else {
                if let snapshot = querySnapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        let batch = self.db.batch()
                        let docset = querySnapshot
                        
                        let newCollRef = userRef.collection("tasks").document()
                        
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
    
    // copy tasks from second bundle to users coll
    func copySecondBundle() {
        let userID = Auth.auth().currentUser!.uid
        let userRef = db.collection("users").document(userID)
        let tasksSecondBundleCollRef = db.collection("tasks").document("secondBundle").collection("tasks")
        
        tasksSecondBundleCollRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err.localizedDescription)")
            } else {
                if let snapshot = querySnapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        let batch = self.db.batch()
                        let docset = querySnapshot
                        
                        let newCollRef = userRef.collection("tasks").document()
                        
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
    
    // to set the elements styling 
    func setUpElements() {
        errorLabel.alpha = 0 // hide the error label
        
        // style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    // check the fields and validate that the data is correct.
    // if everything is correct - return nil (optional type). otherwise, return error message. (method return optional String)
    func validateFields() -> String? {
        
        // check that all fields are filled in
        // if when we get rid of all white spaces and new lines in a field and still have "" (any of fields are empty), then return error
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields!"
        }
        
        // check if the password is secure ( ! is unwrapper from ?, means that there is a text for sure)
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // password isn't secure enough
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number!"
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateFields()
        
        // there's an error, bc something wrong with the fields, so show error message
        if error != nil {
            showError(error!)
        } else {
            
            // create cleaned versions of the data
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // create the user; return err in case of error; return uid via result when successful
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in // code that gets run when the user is created
                
                // there was an error creating the user
                if err != nil  {
                    self.showError("Error creating user!")
                } else { // no errors, user was created successfully, so store the firstname and the lastname
                    let db = Firestore.firestore()
                    
                    // push user data to the db
                    db.collection("users").document(result!.user.uid).setData([
                        "firstname":firstname,
                        "lastname":lastname,
                        "uid":result!.user.uid]) { (error) in
                            if error != nil  { self.showError("Error saving user data!") }
                    }
                    
                    //self.transitionToHome()
                    self.transitionToPoll()
                    
                    // copy tasks for user from general tasks collection to his own tasks collection
                    //self.copyTasks()
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let mainVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController) as? ViewController
        
        view.window?.rootViewController = mainVC
        view.window?.makeKeyAndVisible()
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
    
    func transitionToPoll() {
        let pollViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.pollViewController) as? MainPollViewController
        
        view.window?.rootViewController = pollViewController
        view.window?.makeKeyAndVisible()
    }
}

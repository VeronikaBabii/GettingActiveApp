//
//  ProfileViewController.swift
//  GettingActiveApp
//
//  Created by Veronika Babii on 22.04.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let db = Firestore.firestore()
    var archiveTasksArray = [Task]()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var openArchiveButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    var time: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setUserData()
        setProgressTitle()
        checkForCountUpdates()
        
        updateUI()
    }

    // action to open image picker on click
    @IBAction func uploadImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func updateUI() {
        // set to current time
        time = Date()
        
        timeLabel.text = "\(time!)"
        
        timeLabel.alpha = 0
    }

    func setUp() {
        let navbar = self.navigationController?.navigationBar
        navbar?.barTintColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        navbar?.tintColor = UIColor.black
        
        Utilities.styleFilledButton(openArchiveButton)
    }

    // set user progress title
    func setProgressTitle() {

        let userID = Auth.auth().currentUser!.uid
        let archiveCollRef = db.collection("users").document(userID).collection("archive")

        archiveCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                
                // count snapshots in a collection - number of tasks in archive
                var count = 0
                for _ in queryShapshot!.documents {
                    count += 1
                }

                if count == 0 {
                    self.progressLabel.text = "Ти ще не виконав жодного завдання :("
                } else {
                    switch count {
                    case 1, 2, 3, 4, 21, 22, 23, 24, 31, 32, 33, 34, 41, 42, 43, 44:
                        self.progressLabel.text = "Ти виконав \(count) завдання. Чудова робота!"
                    default:
                        self.progressLabel.text = "Ти виконав \(count) завдань. Чудова робота!"
                    }
                }
            }
        }
    }
    
    func checkForCountUpdates() {
        let userID = Auth.auth().currentUser!.uid
        let archiveCollRef = db.collection("users").document(userID).collection("archive")
        
        archiveCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                
                // listen to archive collection
                archiveCollRef.addSnapshotListener() {
                    querySnapshot, error in
                    
                    guard let snapshot = querySnapshot else {return}
                    
                    snapshot.documentChanges.forEach {
                        diff in
                        
                        // if action is addition - count number of done tasks again
                        if diff.type == .added {
                            
                            var count = 0
                            for _ in querySnapshot!.documents {
                                count += 1
                            }
                            
                            switch count {
                            case 1, 2, 3, 4, 21, 22, 23, 24, 31, 32, 33, 34, 41, 42, 43, 44:
                                self.progressLabel.text = "Ти виконав \(count) завдання. Чудова робота!"
                            default:
                                self.progressLabel.text = "Ти виконав \(count) завдань. Чудова робота!"
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func openArchiveTapped(_ sender: Any) {

    }

    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // get and set user data from db to the label
    func setUserData() {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let currentUserDoc = snapshot?.documents.first(where: { ($0["uid"] as? String) == userId }) {

                        // get and set first and last name
                        let userFirstname = currentUserDoc["firstname"] as! String
                        let userLastname = currentUserDoc["lastname"] as! String
                        self.usernameLabel.text = "\(userFirstname) \(userLastname)"
                    }
                }
            }
        }
    }
}

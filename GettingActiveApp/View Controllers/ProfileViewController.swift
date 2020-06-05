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

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbar()
        getUserData()
        setProgressTitle()

        Utilities.styleFilledButton(openArchiveButton)
    }

    // action to open image picker on click
    @IBAction func uploadImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    func setNavbar() {
        let navbar = self.navigationController?.navigationBar
        navbar?.barTintColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        navbar?.tintColor = UIColor.black
    }

    // set user progress title
    func setProgressTitle() {

        let userID = Auth.auth().currentUser!.uid
        let archiveCollRef = db.collection("users").document(userID).collection("archive")

        archiveCollRef.getDocuments { (queryShapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                var count = 0
                for _ in queryShapshot!.documents {
                    count += 1
                }
                
                if count == 0 {
                    self.progressLabel.text = "No tasks done :( Let's complete first one!"
                } else {
                    switch count {
                    case 1, 21, 31, 41:
                        self.progressLabel.text = "You've done \(count) task. Great job!"
                    default:
                        self.progressLabel.text = "You've done \(count) tasks. Great job!"
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

    // get user data from db
    func getUserData() {
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
